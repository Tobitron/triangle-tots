module Native
  class StorageController < ApplicationController
    allow_unauthenticated_access

    # POST /native/interactions/sync
    # Receive interactions from native storage and merge with user account
    def sync
      interactions_data = params[:interactions]

      if Current.user && interactions_data.present?
        # Merge native storage interactions with user account
        interactions_data.each do |activity_id, data|
          interaction = Current.user.user_interactions.find_or_initialize_by(activity_id: activity_id)

          # Update rating if present
          interaction.rating = data['rating'] if data['rating'].present?

          # Merge completions
          if data['completions'].present?
            existing_completions = interaction.completions || []
            new_completions = data['completions'].map { |c| Time.parse(c) rescue nil }.compact
            interaction.completions = (existing_completions + new_completions).uniq.sort
            interaction.last_completed_at = interaction.completions.last
          end

          interaction.save
        end

        head :ok
      else
        head :unprocessable_entity
      end
    end

    # GET /native/interactions/export
    # Send current user interactions to native app
    def export
      if Current.user
        interactions = {}
        Current.user.user_interactions.each do |ui|
          interactions[ui.activity_id.to_s] = {
            rating: ui.rating,
            completions: ui.completions&.map(&:iso8601) || [],
            lastCompleted: ui.last_completed_at&.iso8601,
            updatedAt: ui.updated_at&.iso8601
          }
        end

        render json: { interactions: interactions }
      else
        head :unauthorized
      end
    end
  end
end

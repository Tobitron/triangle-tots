class UserInteractionsController < ApplicationController
  def rate
    interaction = Current.user.user_interactions.find_or_initialize_by(activity_id: params[:activity_id])
    interaction.rating = params[:rating].to_i
    interaction.save!
    head :ok
  end

  def mark_done
    interaction = Current.user.user_interactions.find_or_initialize_by(activity_id: params[:activity_id])
    interaction.completions ||= []
    interaction.completions << Time.current.iso8601
    interaction.last_completed_at = Time.current
    interaction.save!
    head :ok
  end

  def import
    return head :bad_request unless params[:interactions].is_a?(ActionController::Parameters)

    params[:interactions].each do |activity_id, data|
      next unless Activity.exists?(activity_id)

      interaction = Current.user.user_interactions.find_or_initialize_by(activity_id: activity_id)
      interaction.rating = data[:rating] if data[:rating].present?
      interaction.completions = data[:completions] || [] if data[:completions].present?
      interaction.last_completed_at = data[:last_completed_at] if data[:last_completed_at].present?
      interaction.save
    end
    head :ok
  end
end

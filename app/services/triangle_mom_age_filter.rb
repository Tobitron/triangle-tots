class TriangleMomAgeFilter
  # Events at adult venues are always excluded
  ADULT_VENUE = /brew(ery|ing)\b|winer(y|ies)\b|distiller(y|ies)\b|\btavern\b|cannabis\b|marijuana\b|\bhemp\b/i

  # Content explicitly for older kids or adults
  OLDER_CONTENT = /\bteen(s|ager)?\b|\btween\b|middle school|high school|girl scouts?\b|boy scouts?\b|\badult\b|grown.?up\b|networking\b|comedy show|improv show/i

  # Minimum age stated as 5 or older
  AGE_TOO_OLD = /\bages?\s*(5|6|7|8|9|10|11|12|\d{2})\s*(\+|and up|& ?up)|\b(5|6|7|8|9|10|11|12)\+\s*(year|yr)s?\s*old/i

  # Activities requiring coordination or instruction beyond toddler capability
  COMPLEX_ACTIVITY = /hula (danc|lesson)|cooking class|baking class|sewing class|knitting class|school.?age\b/i

  # Strong signal that an event is designed for babies/toddlers — short-circuits other checks
  TODDLER_SIGNAL = /\btoddler|\bbaby\b|\bbabies\b|\binfant|\blittle (one|tot|tyke)|\bpreschool|\bstory.?time\b|\bopen play\b|\bsensory\b|\bnursery\b/i

  def self.suitable?(event)
    text = [
      event[:name],
      event[:description],
      event[:categories]&.join(" "),
      event[:age_groups]&.join(" ")
    ].compact.join(" ")

    return true if text.match?(TODDLER_SIGNAL)
    return false if text.match?(ADULT_VENUE)
    return false if text.match?(OLDER_CONTENT)
    return false if text.match?(AGE_TOO_OLD)
    return false if text.match?(COMPLEX_ACTIVITY)

    true
  end
end

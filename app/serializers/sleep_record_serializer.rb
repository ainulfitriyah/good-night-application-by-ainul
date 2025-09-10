class SleepRecordSerializer < ActiveModel::Serializer
  attributes :id, :slept_at, :woke_at, :duration_hours, :duration_seconds, :created_at
  belongs_to :user, serializer: UserSerializer

  def slept_at
    object.slept_at.strftime("%d %B %Y %H:%M")
  end

  def woke_at
    object.woke_at&.strftime("%d %B %Y %H:%M")
  end

  def created_at
    object.created_at.strftime("%d %B %Y %H:%M")
  end

  def duration_seconds
    object.duration_seconds
  end

  def duration_hours
    return nil unless object.duration_seconds.present?
    return nil unless object.woke_at.present?
    (object.duration_seconds / 1.hour).round(2)
  end
end

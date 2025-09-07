class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at

  def created_at
    object.created_at.strftime("%d %B %Y %H:%M")
  end
end

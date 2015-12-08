class MemberSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :member_external_id, :client_id, :auth_token
  has_many :memberships
  has_many :retailers, serializer: RetailerForMemberSerializer
end

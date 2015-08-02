class Petition < ActiveRecord::Base
  belongs_to :blood
  belongs_to :institution

  validates :amount, :institution_id, :blood, presence: true

  scope :not_expired, -> {
    where("deadline >= ?", Time.now)
  }

  scope :sort_by_deadline, -> {
    order(:deadline)
  }

  def self.search(params = {})
    petitions = params[:institution_id].present? ? Petition.where(institution_id: params[:institution_id]) : Petition.all
    petitions = petitions.where(blood_id: params[:blood_id]) if params[:blood_id].present?
    petitions.not_expired.sort_by_deadline
  end
end

class Log < ApplicationRecord
    # belongs_to :service, optional: true
    # TAGS = %i[in out in-and-out]
    paginates_per 5
    has_many :availed_services
    has_many :services, through: :availed_services

    belongs_to :customer, optional: true
    belongs_to :vehicle, optional: true

    STATUS = %i[paid unpaid partially_paid]

    enum status: [:unpaid, :paid, :void]

    validates :customer_id, :vehicle_id, :services, :presence => true

    def display_services
      services.map(&:title).join(', ')
    end

    def display_customer
      customer&.display_name
    end

    def display_vehicle
      vehicle&.model
    end

    def display_price
      services.sum(:rate)
    end

    def self.search(search_value)
      logs = self.joins(:services).distinct

      return logs if search_value.nil?

      logs = logs.where(services: {title: search_value[:service]}) unless search_value[:service].empty?
      return logs

    end
end
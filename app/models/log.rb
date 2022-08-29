class Log < ApplicationRecord
    # belongs_to :service, optional: true
    # TAGS = %i[in out in-and-out]
    paginates_per 5
    has_many :availed_services
    has_many :services, through: :availed_services

    belongs_to :customer, optional: true
    belongs_to :vehicle, optional: true

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
end

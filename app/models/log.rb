class Log < ApplicationRecord
    # belongs_to :service, optional: true
    # TAGS = %i[in out in-and-out]
    paginates_per 10
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

    def self.search(params)
      # where('status = ?', 0)
      logs = self.joins(:customer, :services)

      return logs if params.nil?

      logs = logs.where(services: { id: params[:service]}) unless params[:service].empty?
      # logs = logs.where(customer: { id: params[:customer]}) unless params[:customer].empty?
      logs = logs.where("lower(first_name) LIKE ? OR lower(last_name) LIKE ?", "%" + params[:customer].downcase + "%", "%" + params[:customer].downcase + "%") unless params[:customer].empty? 

      logs = logs.where("service_date >= ? AND service_date <= ?", params[:date_from], params[:date_to]) unless params[:date_from].empty?
      # where date >= ? AND date <= ?, date_from, date_to unless params[:date].empty?
      
      logs = logs.distinct

    end
end


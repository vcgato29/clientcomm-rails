module ClientStatusHelper
  def client_statuses(user:)
    output = {}

    ClientStatus.all.map do |status|
      followup_date = Time.now - status.followup_date.days
      warning_period = 5.days

      found_clients = user.clients
                          .active
                          .joins(:reporting_relationships)
                          .where(reporting_relationships: { client_status: status, user: user })
                          .where('reporting_relationships.last_contacted_at < ?', followup_date + warning_period)

      output[status.name] = found_clients.pluck(:id) if found_clients.present?
    end

    output
  end
end

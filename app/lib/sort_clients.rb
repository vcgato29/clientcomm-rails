class SortClients
  def self.clients_list(user:)
    user.clients.joins(:reporting_relationships)
      .where(reporting_relationships: { user: user, active: true })
      .order("reporting_relationships.has_unread_messages, COALESCE(reporting_relationships.last_contacted_at, clients.created_at)")
      .reverse
  end

  def self.mass_messages_list(user:, selected_clients: [])
    user.clients.joins(:reporting_relationships)
      .where(reporting_relationships: { user: user, active: true })
      .order("clients.id IN (#{selected_clients}), COALESCE(reporting_relationships.last_contacted_at, clients.created_at)")
      .reverse
  end
end

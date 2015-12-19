class JobCategory

  def self.get_categories
    return {
        software_development: 1,
        ui_ux_design: 2,
        product_management: 3,
        system_administration: 4,
        finance: 5,
        customer_service: 6,
        sales: 7,
        marketing: 8,
        pr_communications: 9,
        human_resources: 10,
        management: 11,
        operations: 12,
        other: 13
    }
  end
end

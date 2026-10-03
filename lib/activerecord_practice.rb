require 'sqlite3'
require 'active_record'
require 'byebug'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'customers.sqlite3')
# Show queries in the console.
# Comment this line to turn off seeing the raw SQL queries.
ActiveRecord::Base.logger = Logger.new($stdout)

# Normally a separate file in a Rails app.
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

class Customer < ApplicationRecord
  def to_s
    "  [#{id}] #{first} #{last}, <#{email}>, #{birthdate.strftime('%Y-%m-%d')}"
  end

  #  NOTE: Every one of these can be solved entirely by ActiveRecord calls.
  #  You should NOT need to call Ruby library functions for sorting, filtering, etc.

  def self.any_candice
    # YOUR CODE HERE to return all customer(s) whose first name is Candice
    where(first: 'Candice')
    # probably something like:  Customer.where(....)
  end

  def self.with_valid_email
    where("email LIKE ?", "%@%" )
    # YOUR CODE HERE to return only customers with valid email addresses (containing '@')
  end

  def self.with_dot_org_email
    where("email LIKE ?", "%.org" )
  end

  def self.with_invalid_email
    where('email NOT LIKE ? AND email != ?', '%@%', '')
  end

  def self.with_blank_email
    where(email: [nil, ""])
  end

  def self.born_before_1980
    where('birthdate < ?', Time.zone.parse("1 January 1980"))
  end

  def self.with_valid_email_and_born_before_1980
    where('email LIKE ? AND birthdate < ?', "%@%", Time.zone.parse("1 January 1980"))
  end

  def self.last_names_starting_with_b
    where('last LIKE ?', "B%").order(:birthdate)
  end

  def self.twenty_youngest
    order(birthdate: :desc).limit(20)
  # etc. - see README.md for more details
  end

  def self.update_gussie_murray_birthdate
    find_by(first: "Gussie", last: "Murray").update(birthdate: Time.zone.parse("8 February 2004"))
  end
  
  def self.change_all_invalid_emails_to_blank
    with_invalid_email.update_all(email: "")
  end
  
  def self.delete_meggie_herman
    where(first: "Meggie", last: "Herman").destroy_all
  end

  def self.delete_everyone_born_before_1978
    where('birthdate < ?', Time.zone.parse("1 January 1978")).destroy_all
  end

end
module Userable

  def name
    self.user.name
  end

  def name=(new_name)
    self.user.name = new_name
  end

  def uid
    user.uid
  end

  def uid=(new_uid)
    user.uid = new_uid
  end

  def lastname
    user.lastname
  end

  def lastname=(new_lastname)
    user.lastname = new_lastname
  end

  def email
    user.email
  end

  def email=(new_email)
    user.email = new_email
  end

  def gender
    user.gender
  end

  def gender=(new_gender)
    user.gender = new_gender
  end

  def birth
    user.birth
  end

  def birth=(new_birth)
    user.birth = new_birth
  end

  def image_url
    user.image_url
  end

  def image_url=(new_url)
    user.image_url = new_url
  end

end
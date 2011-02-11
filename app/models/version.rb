class Version < ActiveRecord::Base
  has_many :test_results
  belongs_to :rubygem

  validates_uniqueness_of :number, scope: [:rubygem_id]
  validates_presence_of :number, :rubygem_id
  
  before_save :check_prerelease

  def check_prerelease
    self.prerelease = false if self.prerelease.nil?
    not self.prerelease.nil?
  end

  def pass_count
    TestResult.where(result: true, version_id: self.id).count
  end

  def fail_count
    TestResult.where(result: false, version_id: self.id).count
  end
end

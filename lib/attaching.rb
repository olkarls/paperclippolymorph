class Attaching < ActiveRecord::Base
  belongs_to :asset, :counter_cache => true
  belongs_to :attachable, :polymorphic => true
  acts_as_list :scope => 'attachable_id = #{attachable_id} AND attachable_type = \'#{attachable_type}\''
  
  def after_create
    if self.attachable.acts_as_polymorphic_paperclip_options[:counter_cache]
      self.attachable.class.increment_counter(:assets_count, self.attachable.id)
    end
  end
  
  def after_destroy
    if self.attachable.acts_as_polymorphic_paperclip_options[:counter_cache]
      self.attachable.class.decrement_counter(:assets_count, self.attachable.id)
    end
  end
end
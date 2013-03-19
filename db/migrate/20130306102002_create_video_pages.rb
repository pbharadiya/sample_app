class CreateVideoPages < ActiveRecord::Migration
  def self.up
    create_table :video_pages do |t|
      t.integer :site_version_id
      t.string  :title
			t.text    :description
      t.text    :content
      t.string  :youtube_video_id
      t.string  :slug
      t.integer :lead_gen_iframe_id
      t.boolean :resources_sidebar, :default => true, :null => false
      t.integer :resources_sidebar_position, :null => false, :default => 0

      t.timestamps
    end
    
    add_index :video_pages, [:site_version_id, :slug]
  end

  def self.down
    drop_table :video_pages
  end
end
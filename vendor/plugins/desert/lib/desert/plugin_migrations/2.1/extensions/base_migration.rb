ActiveRecord::Migrator.class_eval do

    def initialize_with_almost_version(*args)
        initialize_without_almost_version(*args)
        return if @target_version.nil?

        target = migrations.detect { |m| m.version == @target_version }
        if target.nil?
            # Pick the oldest migration for this version
            new_target = 0
            migrations.each {|m|
                if m.version > new_target and m.version <= @target_version
                    new_target = m.version
                end
            }

            @target_version = new_target
        end
    end

    alias_method_chain :initialize, :almost_version

end

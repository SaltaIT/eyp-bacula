require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'bacula class' do

  context 'basic setup' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOF

      class { 'bacula::fd':
        fdname => 'bacula-fd',
      }

      class { 'bacula::sd':
        sdname => 'bacula-sd',
      }

      bacula::sd::device { 'data1':
        archive_device => '/var/bacula/data1',
      }

      bacula::sd::device { 'data2':
        archive_device => '/var/bacula/data2',
      }

      bacula::sd::autochanger { 'autochanger1':
        devices => [ 'data1', 'data2' ],
      }

      class { 'bacula::dir':
      }

      bacula::dir::catalog { 'mycatalog':
        dbpassword => 'baculapassw0rd',
      }

      bacula::dir::fileset { 'Full':
      }

      bacula::dir::schedule { 'weekly':
        run => [ "Full 1st sun at 23:05", "Incremental mon-sat at 23:05" ],
      }

      bacula::dir::client { 'bacula-fd':
        addr     => '127.0.0.1',
        catalog  => 'mycatalog',
      }

      bacula::dir::storage { 'local-autochanger1':
        password => 'dmlzY2EgY2F0YWx1bnlhIGxsaXVyZQo',
        device   => 'autochanger1',
      }

      bacula::dir::pool { '30days':
        volume_retention => '30 days',
        label_format     => '30days-',
      }

      bacula::dir::job { 'demo':
        client   => 'bacula-fd',
        fileset  => 'Full',
        schedule => 'weekly',
        storage  => 'local-autochanger1',
        pool     => '30days',
      }

      class { 'bacula::bconsole': }

      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

  end
end

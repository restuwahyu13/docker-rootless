const os = require('os')

module.exports = {
	apps: [
		{
			name: 'docker-rootless',
			namespace: 'node',
			script: 'index.js',
			env: {
				NODE_ENV: 'production',
				PORT: 4000
			},
			watch: false,
			autorestart: true,
			exec_mode: 'cluster',
			instances: 'max',
			max_memory_restart: '1024M',
			listen_timeout: 3000,
			kill_timeout: 6000,
			combine_logs: true,
			error_file: `/var/tmp/.pm2/logs/err.log`,
			out_file: `/var/tmp/.pm2/logs/out.log`,
			pid_file: `/var/tmp/.pm2/pm2.pid`
		}
	]
}

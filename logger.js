import log4js from 'log4js';
const logConfig = {
    replaceConsole: true,
    appenders: {
      'out': {
          type: 'stdout',
          layout: {
            type: "colored"
          } 
      },
    'files': {
      type: 'file',
      filename: 'logs.log',
      alwaysIncludePattern: true
    }
  },
  categories: {
    default: {
      appenders: ['out', 'files'],
      level: 'debug'
    }
  },
  disableClustering: true
}
log4js.configure(logConfig)
export const logger = log4js.getLogger("FT");
keys =
  development:
    instagram:
      id: '0a36fb5625154f81ad40d4a1b42578e7'
      secret: '79f160882ff54404ab52fad619cedf5f'
  production:
    instagram:
      id: '5a959c13800340acaa2db39b43b87849'
      secret: '3ca11ab5fa204e5f936ad963682004d4'

module.exports = keys[process.env.NODE_ENV or 'development']
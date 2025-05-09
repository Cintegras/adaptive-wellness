module.exports = function({ addUtilities, theme }) {
  addUtilities({
    '.fc-glow': {
      boxShadow: `0 0 12px ${theme('colors.formcoach.primary')}`,
    },
    '.fc-focus': {
      outline: '2px solid var(--fc-color-text-accent)',
      outlineOffset: '2px',
    },
    '.fc-card-hover': {
      '@apply transition-all duration-200': {},
      '&:hover': {
        transform: 'translateY(-2px)',
        boxShadow: `0 4px 12px rgba(0, 0, 0, 0.1)`,
      }
    },
    '.fc-text-gradient': {
      background: `linear-gradient(90deg, ${theme('colors.formcoach.primary')} 0%, #4AEDC4 100%)`,
      '-webkit-background-clip': 'text',
      '-webkit-text-fill-color': 'transparent',
    }
  });
};
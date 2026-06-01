import { createTheme } from "@mui/material/styles";

// ── Brand palette ────────────────────────────────────────────────────────────
// Core:       White, Black (#000000), Teal (#00AFAA)
// Secondary:  Light grey (#EDEDED), Stone (#BEA791)
const TEAL = "#00AFAA";
const STONE = "#BEA791";
const LIGHT_GREY = "#EDEDED";
const BLACK = "#000000";
const WHITE = "#ffffff";

export const theme = createTheme({
  palette: {
    primary: { main: TEAL, contrastText: WHITE },
    secondary: { main: STONE, contrastText: BLACK },
    background: { default: LIGHT_GREY, paper: WHITE },
    text: { primary: BLACK },
    divider: "rgba(0, 0, 0, 0.12)",
  },
  shape: { borderRadius: 8 },
  components: {
    // Flat, brand-forward buttons.
    MuiButton: { defaultProps: { disableElevation: true } },
    // Teal app bar with white content (brand look).
    MuiAppBar: { styleOverrides: { colorPrimary: { backgroundColor: TEAL, color: WHITE } } },
    // Selected nav item gets a teal tint via the primary palette automatically;
    // make it a touch stronger so the active page reads clearly against light grey.
    MuiListItemButton: {
      styleOverrides: {
        root: {
          "&.Mui-selected": { backgroundColor: "rgba(0, 175, 170, 0.14)" },
          "&.Mui-selected:hover": { backgroundColor: "rgba(0, 175, 170, 0.22)" },
        },
      },
    },
  },
});

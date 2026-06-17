from kitty.tab_bar import DrawData, ExtraData, TabBarData, draw_title, apply_title_template
from kitty.fast_data_types import Screen

# onedark.nvim darker palette
_C = {
    'bg':     0x1f2329,
    'fg':     0xa0a8b7,
    'green':  0x8ebd6b,
    'blue':   0x4fa6ed,
    'purple': 0xbf68d9,
    'yellow': 0xe2b86b,
    'cyan':   0x48b0bd,
}

_MODE_STYLES = {
    'normal': (_C['bg'], _C['green']),
    'pane':   (_C['bg'], _C['blue']),
    'tab':    (_C['bg'], _C['purple']),
    'resize': (_C['bg'], _C['yellow']),
    'move':   (_C['bg'], _C['cyan']),
}

_POWERLINE_SEP = {
    'angled':  '',
    'slanted': '',
    'round':   '',
}


def _sep(draw_data: DrawData) -> str:
    return _POWERLINE_SEP.get(draw_data.powerline_style, draw_data.sep)


def _tab_fg(draw_data: DrawData, tab: TabBarData) -> int:
    if tab.is_active:
        return tab.active_fg if tab.active_fg is not None else int(draw_data.active_fg)
    return tab.inactive_fg if tab.inactive_fg is not None else int(draw_data.inactive_fg)


def _tab_bg(draw_data: DrawData, tab: TabBarData) -> int:
    if tab.is_active:
        return tab.active_bg if tab.active_bg is not None else int(draw_data.active_bg)
    return tab.inactive_bg if tab.inactive_bg is not None else int(draw_data.inactive_bg)


def _keyboard_mode(draw_data: DrawData, tab: TabBarData, index: int) -> str:
    tmpl = draw_data._replace(title_template='{keyboard_mode}', active_title_template=None)
    return apply_title_template(tmpl, tab, index).strip()


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_tab_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    sep = _sep(draw_data)
    tab_bg = _tab_bg(draw_data, tab)

    if index == 1:
        mode = _keyboard_mode(draw_data, tab, index)
        style = _MODE_STYLES.get(mode)
        if style:
            badge_fg, badge_bg = style
            screen.cursor.fg = badge_fg
            screen.cursor.bg = badge_bg
            screen.draw(f' {mode.upper()} ')
            # Transition from badge into first tab
            screen.cursor.fg = badge_bg
            screen.cursor.bg = tab_bg
            screen.draw(sep)

    # Tab body
    screen.cursor.fg = _tab_fg(draw_data, tab)
    screen.cursor.bg = tab_bg
    screen.draw(' ')
    draw_title(draw_data, screen, tab, index, max_tab_length - 2)
    screen.draw(' ')

    # Separator into next tab
    if not is_last and extra_data.next_tab:
        next_bg = _tab_bg(draw_data, extra_data.next_tab)
        screen.cursor.fg = tab_bg
        screen.cursor.bg = next_bg
        screen.draw(sep)

    return screen.cursor.x

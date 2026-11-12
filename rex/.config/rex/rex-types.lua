---@meta
-- Type definitions for the Rex Lua API, for lua-language-server.
-- Rex never loads this file. It exists so the editor knows the global `rex`.
--
-- Written from https://www.superlogical.com/rex/docs/reference/lua
-- The action names are a snapshot of Rex Beta 0.1.0 (1925) for Mac. Any other
-- string is still accepted, so a newer action never shows a warning.
-- Delete this file and .luarc.json once Rex ships its own definitions.

---The Rex API. Rex adds nothing else to the global scope.
---@class rex
rex = {}

--------------------------------------------------------------------------------
-- Shared tables
--------------------------------------------------------------------------------

---What an action, a bound function, a timer, or an event handler runs for.
---A field Rex doesn't know is absent.
---@class rex.Context
---@field session_id? string
---@field block_id? string
---@field client_id? string
---@field origin? string Where the call came from, such as `timer`.
---@field server? string

---@class rex.KeyEvent
---@field keybinding string The key that was pressed.
---@field prefix? string[] For a sequence, the keys before it.

---@class rex.Binding
---@field key string The key or sequence, without its mode.
---@field mode? string
---@field action? string The action name, or nil for a function binding.
---@field fn? function The function, or nil for an action binding.
---@field args? table
---@field source string Where it was bound, such as `keys.lua:3`.

---@class rex.BindingFilter
---@field key? string
---@field mode? string
---@field action? string

---@class rex.Mode
---@field name string
---@field exclusive boolean
---@field source string

---@class rex.ModeOptions
---@field exclusive? boolean Defaults to false.

--------------------------------------------------------------------------------
-- Key bindings
--------------------------------------------------------------------------------

---Binds a key to an action by name, or to a Lua function called as
---`fn(ctx, ev)`. A function returns `true` to mark the key as handled, and
---isn't allowed in a mode.
---
---`key` is a single key (`"cmd+d"`), a sequence written with `>`
---(`"ctrl+b>c"`), or either one prefixed with a mode and a slash
---(`"resize/left"`).
---
---```lua
---rex.bind("cmd+d", "pane.split", { direction = "right" })
---```
---@param key string
---@param action rex.ActionName
---@param args? table Arguments passed to the action.
---@overload fun(key: string, fn: fun(ctx: rex.Context, ev: rex.KeyEvent): boolean?)
function rex.bind(key, action, args) end

---Removes the bindings of a key in this file and in the client's defaults.
---Returns the number of this file's bindings it removed.
---
---`target` limits the removal to bindings with that action name or function.
---`rex.unbind("mode/key")` also blocks the key in that mode.
---`rex.unbind{ mode = name }` removes a whole mode, and passing a table from
---`rex.bindings` removes that one binding.
---@param key string
---@param target? rex.ActionName|function
---@return integer removed
---@overload fun(mode: { mode: string }): integer
---@overload fun(binding: rex.Binding): integer
function rex.unbind(key, target) end

---Declares a mode and sets its options. Configuration file, at load only.
---@param name string
---@param options? rex.ModeOptions
function rex.mode(name, options) end

---Returns the bindings this file and the files it requires have made so far.
---@param filter? rex.BindingFilter
---@return rex.Binding[]
function rex.bindings(filter) end

---Returns the modes declared or bound so far.
---@return rex.Mode[]
function rex.modes() end

--------------------------------------------------------------------------------
-- Actions
--------------------------------------------------------------------------------

---@alias rex.ArgType
---| "string"
---| "string?"
---| "number"
---| "number?"
---| "integer"
---| "integer?"
---| "boolean"
---| "boolean?"
---| "object"
---| "object?"
---| "array"
---| "array?"
---| "any"
---| "any?"

---An action a key can be bound to. Custom actions from rex.action work too.
---@alias rex.ActionName
---| "client.window.new" # New Window
---| "client.window.close" # Close Window
---| "client.window.fullscreen.toggle" # Toggle Full Screen
---| "client.close" # Close
---| "client.palette.toggle" # Command Palette…
---| "client.settings" # Settings…
---| "client.diagnostics" # Rex Diagnostics
---| "client.onboarding" # Open Onboarding Session…
---| "client.permissions" # Grant System Permissions…
---| "client.visibility.toggle" # Toggle Visibility
---| "client.version.copy" # Copy Version Info
---| "client.debug.copy" # Copy Debug Info
---| "client.pair_device" # Pair Device with QR Code…
---| "client.update.accept" # Install Update
---| "client.update.accept_when_idle" # Relaunch when Idle
---| "client.update.check" # Check for Updates in Background
---| "client.update.status" # Report Update Status
---| "client.update.install" # Install Update and Relaunch
---| "client.update.set_automation" # Set Update Automation. Args: level (notify, download, install)
---| "client.update.set_channel" # Set Update Channel. Args: channel (preview, snapshot)
---| "client.notice.dismiss" # Dismiss Notice
---| "client.shortcuts.edit" # Change Shortcut…
---| "client.agents.setup" # Install Rex for Agents
---| "client.server.restart" # Restart Server…
---| "session.new" # New Session
---| "session.switch" # Change Session…
---| "session.select" # Go to Session. Args: session_id, window_id?
---| "session.next" # Next Session
---| "session.previous" # Previous Session
---| "session.rename" # Rename Session
---| "session.close" # Close Session
---| "session.refresh" # Refresh Sessions
---| "session.open_on_web" # Open Session on Web…
---| "session.collapse" # Collapse Session. Args: session_id?
---| "session.expand" # Expand Session. Args: session_id?
---| "session.collapse_others" # Collapse Other Sessions. Args: session_id?
---| "client.host.switch" # Switch Host
---| "client.host.add" # Add Remote Host…
---| "client.host.remove" # Remove Host…
---| "client.tab.new" # New Tab
---| "client.tab.close" # Close Tab
---| "client.tab.close_others" # Close Other Tabs
---| "client.tab.rename" # Rename Tab
---| "client.tab.next" # Show Next Tab
---| "client.tab.previous" # Show Previous Tab
---| "client.tab.goto" # Go to Tab. Args: index
---| "client.tab.move" # Move Tab. Args: direction (backward, forward)
---| "client.tab.move.backward" # Move Tab Backward
---| "client.tab.move.forward" # Move Tab Forward
---| "client.tab.move_to_new_window" # Move Tab to New Window
---| "pane.split" # Split Pane. Args: direction (right, down, left, up, auto)
---| "pane.split.left" # Split Pane Left
---| "pane.split.right" # Split Pane Right
---| "pane.split.up" # Split Pane Up
---| "pane.split.down" # Split Pane Down
---| "pane.split.auto" # Split Pane Best Fit
---| "pane.focus" # Focus Pane. Args: direction (left, right, up, down), wrap?
---| "pane.focus.left" # Focus Pane Left
---| "pane.focus.right" # Focus Pane Right
---| "pane.focus.up" # Focus Pane Up
---| "pane.focus.down" # Focus Pane Down
---| "pane.focus_next" # Focus Next Pane
---| "pane.focus_previous" # Focus Previous Pane
---| "pane.move" # Move Pane. Args: direction (left, right, up, down)
---| "pane.move.left" # Move Pane Left
---| "pane.move.right" # Move Pane Right
---| "pane.move.up" # Move Pane Up
---| "pane.move.down" # Move Pane Down
---| "pane.float" # Float Pane
---| "pane.new_floating" # New Floating Pane
---| "pane.minimize_floating" # Minimize Floating Window
---| "pane.minimize_all_floating" # Minimize Floating Windows
---| "pane.zoom" # Zoom Pane
---| "pane.close" # Close Pane
---| "pane.close_others" # Close Other Panes
---| "pane.balance" # Balance Splits
---| "pane.resize" # Resize Pane. Args: amount?, direction (left, right, up, down)
---| "pane.move_to_new_tab" # Move Pane to New Tab
---| "pane.move_to_tab" # Move Pane to Tab…
---| "pane.go_to_directory" # Go to Directory…
---| "pane.go_to" # Go to Anything…
---| "pane.view_activity" # View Activity…
---| "pane.insert_path" # Insert Path…
---| "pane.copy_id" # Copy Pane ID
---| "pane.rename" # Rename Pane
---| "pane.paste" # Paste into Pane
---| "pane.copy" # Copy from Pane
---| "pane.select_all" # Select All in Pane
---| "pane.send_key" # Send Key. Args: key
---| "client.key.forward" # Send Key to Server
---| "client.prompt.previous" # Jump to Previous Prompt
---| "client.prompt.next" # Jump to Next Prompt
---| "client.scroll.page_up" # Scroll Page Up
---| "client.scroll.page_down" # Scroll Page Down
---| "client.quick_look" # Quick Look
---| "client.mode.enter" # Enter Mode. Args: name, once?
---| "client.mode.exit" # Exit Mode
---| "client.mode.exit_all" # Exit All Modes
---| "client.find.open" # Find…
---| "client.find.next" # Find Next
---| "client.find.previous" # Find Previous
---| "client.font.increase" # Increase Font Size
---| "client.font.decrease" # Decrease Font Size
---| "client.font.reset" # Reset Font Size
---| "client.sidebar.toggle" # Toggle Sidebar
---| "client.sidebar.activity.toggle" # Toggle Activity
---| "client.sidebar.activity.by_session" # Show Activity by Session
---| "client.sidebar.activity.by_priority" # Show Activity by Priority
---| "client.sidebar.filter.focus" # Focus Tab Filter
---| "client.tab_style.toggle" # Toggle Toolbar Layout
---| "client.toolbar.reveal" # Reveal Toolbar
---| "client.pane_header.reveal" # Reveal Pane Header
---| "client.theme.change" # Change Theme…. Args: name?
---| "client.theme.import" # Import Theme File. Args: path
---| "client.appearance.switch_mode" # Switch Appearance Mode. Args: mode (light, dark, toggle)
---| "client.config.copy_path" # Copy Config File Path
---| "client.config.reload" # Reload Config
---| "com.superlogical.onboarding.set_step" # Move the walkthrough to another step. Emits step_changed when the step changes. Args: step
---| "com.superlogical.onboarding.state" # Return the step the walkthrough is on.
---| "com.superlogical.terminal.blob_read" # Read a result that was too large for one reply or event, such as the output of format with max_bytes set, or a selection_copied event without text. The server keeps each result for about five minutes. Args: id?, offset?, max_bytes?
---| "com.superlogical.terminal.clear" # Clear Terminal
---| "com.superlogical.terminal.clipboard_read" # Read text that a program in the terminal copied to the clipboard. The server keeps each copy for about a minute, so a client can read text too large to send in an event. Args: id?, offset?, max_bytes?
---| "com.superlogical.terminal.format" # Get the screen and scrollback as plain text, HTML, or escape sequences. Args: format?, trim?, unwrap?, extra_charsets?, extra_cursor?, extra_hyperlink?, extra_keyboard?, extra_kitty_keyboard?, extra_modes?, extra_palette?, extra_protection?, extra_pwd?, extra_scrolling_region?, extra_style?, extra_tabstops?, max_bytes?
---| "com.superlogical.terminal.input_mode" # Get how the terminal handles typed input, such as whether it is echoed. On Windows the call fails with not_found.
---| "com.superlogical.terminal.list_dir" # List the subdirectories of a directory, and optionally its files. A relative path or ~ is resolved the way a program in the terminal would resolve it. Args: path?, prefix?, limit?, files?
---| "com.superlogical.terminal.modes" # List the terminal modes that programs can turn on, such as the alternate screen, bracketed paste, and mouse reporting, with each mode's name, number, and whether it is on. It doesn't wake an idle terminal.
---| "com.superlogical.terminal.process" # Get the processes running in the terminal and how its program exited.
---| "com.superlogical.terminal.program_status" # List the status that programs in the terminal have reported. Programs report a status, such as working or blocked, with OSC 7501 escape sequences.
---| "com.superlogical.terminal.pwd" # Get the working directory that a program in the terminal last reported. To find where each process actually is, call process instead.
---| "com.superlogical.terminal.reset" # Reset Terminal
---| "com.superlogical.terminal.resize" # Request a terminal size in columns and rows. It applies at once if the caller owns the block or no client does, and otherwise when the caller becomes the owner. Args: columns, rows, cell_width_px?, cell_height_px?
---| "com.superlogical.terminal.set_theme" # Replace the terminal's default colors. As with resize, they apply at once if the caller owns the block or no client does, and otherwise when the caller becomes the owner. Args: foreground?, background?, cursor?, palette?, scheme?
---| "com.superlogical.terminal.size" # Get the terminal's size, its owner, and the size each client last requested.
---| "com.superlogical.terminal.title" # Get the terminal's title and the process that set it.
---| "com.superlogical.terminal.upload_begin" # Reserve a file to upload to the terminal's machine, such as one the user dropped on the terminal, and get a ticket for the rex.data.bytes.v1 data stream that carries its bytes. Once every file of the batch has arrived, the terminal types their paths as if the user had pasted them. Args: ref, name, size, batch?, index?, count?
---| "com.superlogical.terminal.write" # Type text into the terminal as if the user had typed it. The call returns once the text is queued, without waiting for the program to read it. Args: data
---| string

---@class rex.ActionSpec
---@field name string Lowercase letters, digits, and underscores.
---@field title string Shown in the command palette.
---@field run fun(ctx: rex.Context, args: table): any Its return value is the action's result.
---@field description? string A longer explanation.
---@field category? string A group for the palette. Defaults to `Actions`.
---@field keywords? string Extra words for search.
---@field args? table<string, rex.ArgType>|table Argument types, or a JSON Schema.
---@field repeats? boolean Run again while the key is held.

---Defines an action. Once defined it can be bound to a key, and it appears
---in the command palette. At load only.
---
---```lua
---rex.action{
---  name  = "scratch",
---  title = "Open Scratch Window",
---  run   = function(ctx, args) end,
---}
---```
---@param spec rex.ActionSpec
function rex.action(spec) end

---Runs an action and returns its result, or `nil` and an error message.
---In the configuration file only that file's own actions can be invoked.
---Calls can nest up to 16 deep.
---@param name rex.ActionName
---@param args? table
---@return any result
---@return string? err
function rex.invoke(name, args) end

---@class rex.client
rex.client = {}

---Asks the client to perform one of its own actions, such as `pane.zoom`.
---In an action, queued actions run in order after `run` returns, and are
---discarded if it fails. Raises an error when there is no client to ask.
---@param name rex.ActionName
---@param args? table
function rex.client.queue(name, args) end

--------------------------------------------------------------------------------
-- Calling Rex
--------------------------------------------------------------------------------

---Session methods. Each returns a result table, or `nil` and an error
---message. `session_id` is filled in when it is left out. These fail at load
---time in the configuration file, so call them inside an action or handler.
---@class rex.SessionApi
rex.session = {}

---Attach to a session: start receiving its events and get its current view.
---@param args? table
---@return table? result
---@return string? err
function rex.session.attach(args) end

---Start receiving events from the whole server and get the list of sessions.
---@param args? table
---@return table? result
---@return string? err
function rex.session.attach_all(args) end

---Set up a new connection in one call: receive events, list sessions, and attach.
---@param args? table
---@return table? result
---@return string? err
function rex.session.bootstrap(args) end

---Close a floating layer and every block in it.
---@param args? table
---@return table? result
---@return string? err
function rex.session.close_layer(args) end

---Close a window and every block in it.
---@param args? table
---@return table? result
---@return string? err
function rex.session.close_window(args) end

---Create a session, optionally with its first windows already in it.
---@param args? table
---@return table? result
---@return string? err
function rex.session.create(args) end

---Get a block's details and the methods, events, and actions it provides.
---@param args? table
---@return table? result
---@return string? err
function rex.session.describe_block(args) end

---Destroy a session and close every block in it.
---@param args? table
---@return table? result
---@return string? err
function rex.session.destroy(args) end

---Detach the connection from a session. The connection stays open and the session keeps running.
---@param args? table
---@return table? result
---@return string? err
function rex.session.detach(args) end

---Take a block out of its window without closing it. The block keeps running.
---@param args? table
---@return table? result
---@return string? err
function rex.session.detach_block(args) end

---Give up the calling client's claim on blocks. The result lists each block's owner.
---@param args? table
---@return table? result
---@return string? err
function rex.session.disown_block(args) end

---Move a block out of its window's layout into a new floating layer.
---@param args? table
---@return table? result
---@return string? err
function rex.session.float_block(args) end

---Focus a block, and make its window the active window if it isn't.
---@param args? table
---@return table? result
---@return string? err
function rex.session.focus_block(args) end

---Move focus to the nearest block to the left, right, above, or below.
---@param args? table
---@return table? result
---@return string? err
function rex.session.focus_direction(args) end

---Move focus to the next block in the active window.
---@param args? table
---@return table? result
---@return string? err
function rex.session.focus_next_pane(args) end

---Make the next window the active window.
---@param args? table
---@return table? result
---@return string? err
function rex.session.focus_next_window(args) end

---Move focus to the previous block in the active window.
---@param args? table
---@return table? result
---@return string? err
function rex.session.focus_previous_pane(args) end

---Make the previous window the active window.
---@param args? table
---@return table? result
---@return string? err
function rex.session.focus_previous_window(args) end

---Make a window the active window. Focus goes to the block it last had focused.
---@param args? table
---@return table? result
---@return string? err
function rex.session.focus_window(args) end

---Describe the methods this session accepts and the methods its blocks provide.
---@param args? table
---@return table? result
---@return string? err
function rex.session.help(args) end

---List the sessions on the server.
---@param args? table
---@return table? result
---@return string? err
function rex.session.list(args) end

---List every block in the session, including detached blocks.
---@param args? table
---@return table? result
---@return string? err
function rex.session.list_blocks(args) end

---List the clients attached to the session.
---@param args? table
---@return table? result
---@return string? err
function rex.session.list_clients(args) end

---Move a floating layer to the back, or just below another floating layer.
---@param args? table
---@return table? result
---@return string? err
function rex.session.lower_layer(args) end

---Move a session to another place in the order that session.list returns.
---@param args? table
---@return table? result
---@return string? err
function rex.session.move(args) end

---Move a block, or place a detached one, in a new split beside another block.
---@param args? table
---@return table? result
---@return string? err
function rex.session.move_block(args) end

---Move a window to another place in the session's window order.
---@param args? table
---@return table? result
---@return string? err
function rex.session.move_window(args) end

---Create a block without placing it in a window. Place it later with session.move_block.
---@param args? table
---@return table? result
---@return string? err
function rex.session.new_block(args) end

---Create blocks in a new floating layer at the front of a window.
---@param args? table
---@return table? result
---@return string? err
function rex.session.new_layer(args) end

---Create blocks in a new split beside an existing block or split.
---@param args? table
---@return table? result
---@return string? err
function rex.session.new_split(args) end

---Create a window and the blocks in its layout. It becomes the active window by default.
---@param args? table
---@return table? result
---@return string? err
function rex.session.new_window(args) end

---Claim blocks for the calling client. The result lists each block's owner.
---@param args? table
---@return table? result
---@return string? err
function rex.session.own_block(args) end

---Move a floating layer to the front, or just above another floating layer.
---@param args? table
---@return table? result
---@return string? err
function rex.session.raise_layer(args) end

---Move or resize a floating layer.
---@param args? table
---@return table? result
---@return string? err
function rex.session.resize_layer(args) end

---Move the border between two blocks to change their sizes.
---@param args? table
---@return table? result
---@return string? err
function rex.session.resize_pane(args) end

---Set a block's label.
---@param args? table
---@return table? result
---@return string? err
function rex.session.set_block_label(args) end

---Set the session's label.
---@param args? table
---@return table? result
---@return string? err
function rex.session.set_label(args) end

---Minimize a floating layer or return it to normal, optionally raising and focusing it.
---@param args? table
---@return table? result
---@return string? err
function rex.session.set_layer_state(args) end

---Set a window's label.
---@param args? table
---@return table? result
---@return string? err
function rex.session.set_window_label(args) end

---Swap the places of two blocks.
---@param args? table
---@return table? result
---@return string? err
function rex.session.swap_blocks(args) end

---Get the session's windows, their layouts, and their blocks in one snapshot.
---@param args? table
---@return table? result
---@return string? err
function rex.session.view(args) end

---Zoom a block to fill its window, or undo the zoom.
---@param args? table
---@return table? result
---@return string? err
function rex.session.zoom_block(args) end

---Calls any server method by its full name, including the ones `rex.session`
---doesn't cover. Returns a result table, or `nil` and an error message.
---
---```lua
---local result, err = rex.call("session.list")
---```
---@param method string
---@param args? table
---@return table? result
---@return string? err
function rex.call(method, args) end

---@class rex.BlockApi
rex.block = {}

---Calls a method on a block. `creator` is the full name of the kind of
---block. `block_id` is filled in from the current block when it is left out.
---
---```lua
---local title = rex.block.call("com.superlogical.terminal", "title", {}).title
---```
---@param creator string
---@param method string
---@param args? table
---@return table? result
---@return string? err
function rex.block.call(creator, method, args) end

--------------------------------------------------------------------------------
-- Layouts
--------------------------------------------------------------------------------

---@class rex.TerminalOptions
---@field command? string[] The program to run and its arguments. Without it, an interactive shell starts.
---@field shell? string The shell to use. `none` starts `command` directly.
---@field cwd? string The working directory.
---@field initial_input? string Text typed into the terminal once it starts.
---@field exit? { on_completion: boolean } `{ on_completion = false }` keeps the terminal open after its program exits.

---@class rex.LayoutBlockSpec
---@field flavor string What to create, such as `com.superlogical.terminal.shell`.
---@field options? rex.TerminalOptions|table
---@field label? string

---A layout table, as taken by `new_window`, `new_split`, and `new_layer`.
---@class rex.Layout

---Functions that build layout tables. They only build tables and call nothing.
---@class rex.layout
rex.layout = {}

---One block.
---@param spec rex.LayoutBlockSpec
---@return rex.Layout
function rex.layout.block(spec) end

---Two layouts split horizontally.
---@param ratio number The share given to `a`, from 0 to 1.
---@param a rex.Layout
---@param b rex.Layout
---@return rex.Layout
function rex.layout.horizontal(ratio, a, b) end

---Two layouts split vertically.
---@param ratio number The share given to `a`, from 0 to 1.
---@param a rex.Layout
---@param b rex.Layout
---@return rex.Layout
function rex.layout.vertical(ratio, a, b) end

--------------------------------------------------------------------------------
-- Events (scripts run with `rex do` only)
--------------------------------------------------------------------------------

---@alias rex.EventName
---| "window_created" # A window is created. Fields: window_id, label
---| "window_closed" # A window is closed. Fields: window_id
---| "window_label_changed" # A window is renamed. Fields: window_id, label
---| "active_window_changed" # A different window becomes the active one. Fields: window_id
---| "block_created" # A block is created. Fields: block_id
---| "block_closed" # A block is closed. Fields: block_id
---| "session_label_changed" # The session is renamed. Fields: label
---| "session_view_changed" # The session's layout changes in any way. Fields: revision
---| "client_connected" # A client attaches to the session. Fields: client_id, principal, connected_at
---| "client_disconnected" # A client detaches from the session. Fields: client_id, principal
---| "client_connection_changed" # An attached client's connection is lost or restored. Fields: client_id, principal, connection_state
---| "creator_changed" # The kinds of block the session can create have changed.
---| "block_event" # Every event from every block. Tell them apart with ev.creator_name and ev.name.
---| "terminal.child_exited" # The terminal's program exits. Fields: exit_code, error
---| "terminal.pwd_changed" # The program reports a new working directory. Fields: pwd, owner
---| "terminal.title_changed" # The terminal's title changes. Fields: title, owner
---| "terminal.bell" # The terminal receives a bell character.
---| "terminal.process_changed" # The foreground process changes. Fields: generation, foreground, ancestors
---| "terminal.desktop_notification" # The program asks for a desktop notification. Fields: title, body
---| "terminal.progress_report" # The program reports progress. Fields: state, progress
---| "terminal.clipboard_written" # The program writes to the clipboard. Fields: text
---| "terminal.program_status_changed" # A program reports or updates its status. Fields: id, record, reason
---| "terminal.program_status_removed" # Program status records are removed. Fields: ids, reason
---| "session_created" # A session is created. Fields: session
---| "session_destroyed" # A session is destroyed. Fields: session_id
---| "client_joined" # A client connects to the server. Fields: client
---| "client_left" # A client disconnects from the server. Fields: client_id
---| "client_changed" # A connected client's details change. Fields: client
---| "keymap_changed" # The configuration file is reloaded. Fields: generation, hash
---| "hosts_changed" # The list of hosts changes. Fields: hash
---| "tailscale_status_changed" # The server's Tailscale status changes.
---| string

---An event. Its own fields are found directly on it, and again in `payload`.
---@class rex.Event
---@field type string The event's type. For every terminal event this is `block_event`.
---@field session_id? string The session the event happened in. Absent for most server events.
---@field payload table The event's own fields again, as a table of their own.
---@field block_id? string Block events: the block the event came from.
---@field creator_name? string Block events: the kind of block, such as `com.superlogical.terminal`.
---@field name? string Block events: the event's name without the creator, such as `bell`.
---@field [string] any

---Calls `fn(ctx, ev)` each time `event` happens. Scripts only: in the
---configuration file this is a warning at load and an error later.
---@param event rex.EventName
---@param fn fun(ctx: rex.Context, ev: rex.Event)
function rex.on(event, fn) end

---Blocks until `event` happens, and returns `ev` and `ctx`. Returns `nil` and
---`"timeout"` if `timeout` seconds pass first. Scripts only.
---@param event rex.EventName
---@param filter? table|fun(ev: rex.Event, ctx: rex.Context): boolean Fields the event must match, or a function that returns true for a match.
---@param timeout? number Seconds.
---@return rex.Event? ev
---@return rex.Context|string ctx_or_err
---@overload fun(event: rex.EventName, timeout: number): rex.Event?, rex.Context|string
function rex.wait(event, filter, timeout) end

---Blocks for a number of seconds, which may be fractional. Scripts only.
---@param seconds number
function rex.sleep(seconds) end

---Ends the script immediately. `rex do` exits with `code`, or 0. Scripts only.
---@param code? integer
function rex.stop(code) end

--------------------------------------------------------------------------------
-- Hosts and other servers
--------------------------------------------------------------------------------

---@class rex.HostSpec
---@field label string The host's name.
---@field endpoints? string[] A list of addresses, tried in order.
---@field endpoint? string A single address, in place of `endpoints`.
---@field id? string A stable ID, so the host keeps its identity when renamed.
---@field icon? string An icon name for clients to show.

---Declares another Rex server you connect to. Configuration file only.
---@param spec rex.HostSpec
function rex.host(spec) end

---Returns the labels of the other servers available to the running action
---or script.
---@return string[]
function rex.servers() end

---The same `session`, `block`, and `call` functions as `rex`, with calls
---going to another server. They don't fill in a `session_id` or `block_id`.
---@class rex.Server
---@field session rex.SessionApi
---@field block rex.BlockApi
---@field call fun(method: string, args?: table): table?, string?

---Returns the API for another server. Raises an error for an unknown label.
---@param label string
---@return rex.Server
function rex.server(label) end

--------------------------------------------------------------------------------
-- Running commands
--------------------------------------------------------------------------------

---@class rex.ExecOpts
---@field cwd? string The working directory. Defaults to Rex's own.
---@field env? table<string, string|false> Environment variables to set. `false` removes one.
---@field clear_env? boolean `true` starts from an empty environment. `env` still applies.
---@field stdin? string A string written to the command's standard input.
---@field timeout? number Seconds until the command is sent `SIGTERM`, then `SIGKILL` two seconds later.
---@field stdout? boolean `false` discards the stream. Captured by default.
---@field stderr? boolean `false` discards the stream. Captured by default.
---@field text? boolean `false` keeps `\r\n` in the output on Windows.

---@class rex.ExecStartOpts
---@field cwd? string The working directory. Defaults to Rex's own.
---@field env? table<string, string|false> Environment variables to set. `false` removes one.
---@field clear_env? boolean `true` starts from an empty environment. `env` still applies.
---@field stdin? string|boolean A string written to standard input, or `true` to keep it open for `h:write`.
---@field timeout? number Seconds until the command is sent `SIGTERM`, then `SIGKILL` two seconds later.
---@field stdout? boolean|fun(data: string) `false` discards the stream. A function is called with each piece of output as it arrives.
---@field stderr? boolean|fun(data: string) `false` discards the stream. A function is called with each piece of output as it arrives.
---@field text? boolean `false` keeps `\r\n` in the output on Windows.
---@field detach? boolean `true` lets the command outlive the work that started it.

---@class rex.ExecResult
---@field code integer The exit status, or `-1` if a signal ended the command.
---@field signal? string The name of that signal, such as `SIGTERM`.
---@field stdout string What the command printed. `""` when it printed nothing.
---@field stderr string What the command printed to standard error.
---@field timed_out boolean `true` if `timeout` stopped the command.
---@field ok boolean `true` if `code` is 0 and the command didn't time out.

---@class rex.ExecHandle
---@field pid integer The command's process ID.
local ExecHandle = {}

---Waits for the command to exit. Returns `nil` and `"timeout"` if `seconds`
---pass first.
---@param seconds? number
---@return rex.ExecResult? result
---@return string? err
function ExecHandle:wait(seconds) end

---Writes to standard input. Returns `true`, or `nil` and an error message.
---@param data string
---@return true? ok
---@return string? err
function ExecHandle:write(data) end

---Closes standard input.
function ExecHandle:close_stdin() end

---Sends a signal, `SIGTERM` by default.
---@param signal? string|integer A name, such as `SIGINT`, or a number.
function ExecHandle:kill(signal) end

---Returns whether the command is still running.
---@return boolean
function ExecHandle:running() end

---Runs a command, waits for it to exit, and returns a result table. Returns
---`nil` and an error message only when the command never ran. A non-zero
---exit is still a result, so check `ok`.
---
---`argv` is the program, then each of its arguments. No shell reads it.
---
---```lua
---local r, err = rex.exec({ "git", "status", "--short" }, { cwd = dir })
---```
---@class rex.exec
---@overload fun(argv: string[], opts?: rex.ExecOpts): rex.ExecResult?, string?
rex.exec = {}

---Starts a command and returns a handle without waiting, or `nil` and an
---error message.
---@param argv string[]
---@param opts? rex.ExecStartOpts
---@return rex.ExecHandle? handle
---@return string? err
function rex.exec.start(argv, opts) end

--------------------------------------------------------------------------------
-- Timers (scripts run with `rex do` only)
--------------------------------------------------------------------------------

---@class rex.Timer
local Timer = {}

---Stops the timer.
function Timer:cancel() end

---Returns `true` until the timer is cancelled or has fired for the last time.
---@return boolean
function Timer:active() end

---Calls `fn(ctx)` once, after `seconds`. Scripts only.
---@param seconds number May be zero or fractional.
---@param fn fun(ctx: rex.Context)
---@return rex.Timer
function rex.after(seconds, fn) end

---Calls `fn(ctx)` every `seconds` until the timer is cancelled. Scripts only.
---@param seconds number Must be more than zero.
---@param fn fun(ctx: rex.Context)
---@return rex.Timer
function rex.every(seconds, fn) end

--------------------------------------------------------------------------------
-- JSON and logging
--------------------------------------------------------------------------------

---@class rex.json
rex.json = {}

---Turns a Lua value into JSON text, or returns `nil` and an error message.
---@param value any
---@param opts? { indent: boolean } `indent = true` indents the text by two spaces.
---@return string? text
---@return string? err
function rex.json.encode(value, opts) end

---Turns JSON text into a Lua value, or returns `nil` and an error message.
---`null` becomes `nil`, and a `null` in an array is dropped.
---@param text string
---@return any value
---@return string? err
function rex.json.decode(text) end

---Writes a log message. `level` defaults to `info`.
---@param level "debug"|"info"|"warn"|"error"
---@param message string
---@overload fun(message: string)
function rex.log(level, message) end

--------------------------------------------------------------------------------
-- Script values (nil in the configuration file)
--------------------------------------------------------------------------------

---The script's arguments. Empty when none were passed. Scripts only.
---@type table
rex.args = {}

---The ID of the session the script runs against. Scripts only.
---@type string
rex.session_id = nil

---The ID of the block the script runs against, or `nil`. Scripts only.
---@type string?
rex.block_id = nil

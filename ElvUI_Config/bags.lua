local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, ProfileDB, GlobalDB
local B = E:GetModule('Bags')

E.Options.args.bags = {
	type = 'group',
	name = L["Bags"],
	childGroups = "tab",
	get = function(info) return E.db.bags[ info[#info] ] end,
	set = function(info, value) E.db.bags[ info[#info] ] = value end,
	args = {
		intro = {
			order = 1,
			type = 'description',
			name = L["BAGS_DESC"],
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			desc = L["Enable/Disable the all-in-one bag."],
			get = function(info) return E.private.bags.enable end,
			set = function(info, value) E.private.bags.enable = value; E:StaticPopup_Show("PRIVATE_RL") end
		},
		general = {
			order = 3,
			type = "group",
			name = L["General"],
			disabled = function() return not E.bags end,
			args = {
				header = {
					order = 0,
					type = "header",
					name = L["General"],
				},
				currencyFormat = {
					order = 1,
					type = 'select',
					name = L["Currency Format"],
					desc = L["The display format of the currency icons that get displayed below the main bag. (You have to be watching a currency for this to display)"],
					values = {
						['ICON'] = L["Icons Only"],
						['ICON_TEXT'] = L["Icons and Text"],
						["ICON_TEXT_ABBR"] = L["Icons and Text (Short)"],
					},
					set = function(info, value) E.db.bags[ info[#info] ] = value; B:UpdateTokens(); end,
				},
				moneyFormat = {
					order = 2,
					type = 'select',
					name = L["Money Format"],
					desc = L["The display format of the money text that is shown at the top of the main bag."],
					values = {
						['SMART'] = L["Smart"],
						['FULL'] = L["Full"],
						['SHORT'] = L["Short"],
						['SHORTINT'] = L["Short (Whole Numbers)"],
						['CONDENSED'] = L["Condensed"],
						['BLIZZARD'] = L["Blizzard Style"],
					},
					set = function(info, value) E.db.bags[ info[#info] ] = value; B:UpdateGoldText(); end,
				},
				moneyCoins = {
					order = 3,
					type = 'toggle',
					name = L["Show Coins"],
					desc = L["Use coin icons instead of colored text."],
					set = function(info, value) E.db.bags[ info[#info] ] = value; B:UpdateGoldText(); end,
				},
				junkIcon = {
					order = 4,
					type = 'toggle',
					name = L["Show Junk Icon"],
					desc = L["Display the junk icon on all grey items that can be vendored."],
					set = function(info, value) E.db.bags[ info[#info] ] = value; B:UpdateAllBagSlots(); end,
				},
				sortInverted = {
					order = 5,
					type = 'toggle',
					name = L["Sort Inverted"],
					desc = L["Direction the bag sorting will use to allocate the items."],
				},
				countGroup = {
					order = 6,
					type = "group",
					name = L["Item Count Font"],
					guiInline = true,
					args = {
						countFont = {
							order = 1,
							type = "select",
							dialogControl = 'LSM30_Font',
							name = L["Font"],
							values = AceGUIWidgetLSMlists.font,
							set = function(info, value) E.db.bags.countFont = value; B:UpdateCountDisplay() end,
						},
						countFontColor = {
							order = 2,
							type = 'color',
							name = L["Color"],
							get = function(info)
								local t = E.db.bags[ info[#info] ]
								local d = P.bags[info[#info]]
								return t.r, t.g, t.b, t.a, d.r, d.g, d.b
							end,
							set = function(info, r, g, b)
								E.db.bags[ info[#info] ] = {}
								local t = E.db.bags[ info[#info] ]
								t.r, t.g, t.b = r, g, b
								B:UpdateCountDisplay()
							end,
						},
						countFontSize = {
							order = 3,
							type = "range",
							name = L["Font Size"],
							min = 4, max = 212, step = 1,
							set = function(info, value) E.db.bags.countFontSize = value; B:UpdateCountDisplay() end,
						},
						countFontOutline = {
							order = 4,
							type = "select",
							name = L["Font Outline"],
							set = function(info, value) E.db.bags.countFontOutline = value; B:UpdateCountDisplay() end,
							values = {
								['NONE'] = L["None"],
								['OUTLINE'] = 'OUTLINE',
								['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
								['THICKOUTLINE'] = 'THICKOUTLINE',
							},
						},
					},
				},
				itemLevelGroup = {
					order = 7,
					type = "group",
					name = L["Item Level"],
					guiInline = true,
					args = {
						itemLevel = {
							order = 1,
							type = 'toggle',
							name = L["Display Item Level"],
							desc = L["Displays item level on equippable items."],
							set = function(info, value) E.db.bags.itemLevel = value; B:UpdateItemLevelDisplay() end,
						},
						useTooltipScanning = {
							order = 2,
							type = 'toggle',
							name = L["Use Tooltip Scanning"],
							desc = L["This makes the item level display more reliable but uses more resources. If this is disabled then upgraded items will not show the correct item level."],
							set = function(info, value) E.db.bags.useTooltipScanning = value; B:UpdateItemLevelDisplay() end,
						},
						itemLevelThreshold = {
							order = 3,
							name = L["Item Level Threshold"],
							desc = L["The minimum item level required for it to be shown."],
							type = 'range',
							min = 1, max = 1000, step = 1,
							disabled = function() return not E.db.bags.itemLevel end,
							set = function(info, value) E.db.bags.itemLevelThreshold = value; B:UpdateItemLevelDisplay() end,
						},
						itemLevelFont = {
							order = 4,
							type = "select",
							dialogControl = 'LSM30_Font',
							name = L["Font"],
							values = AceGUIWidgetLSMlists.font,
							disabled = function() return not E.db.bags.itemLevel end,
							set = function(info, value) E.db.bags.itemLevelFont = value; B:UpdateItemLevelDisplay() end,
						},
						itemLevelFontSize = {
							order = 5,
							type = "range",
							name = L["Font Size"],
							min = 4, max = 212, step = 1,
							disabled = function() return not E.db.bags.itemLevel end,
							set = function(info, value) E.db.bags.itemLevelFontSize = value; B:UpdateItemLevelDisplay() end,
						},
						itemLevelFontOutline = {
							order = 6,
							type = "select",
							name = L["Font Outline"],
							disabled = function() return not E.db.bags.itemLevel end,
							set = function(info, value) E.db.bags.itemLevelFontOutline = value; B:UpdateItemLevelDisplay() end,
							values = {
								['NONE'] = L["None"],
								['OUTLINE'] = 'OUTLINE',
								['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
								['THICKOUTLINE'] = 'THICKOUTLINE',
							},
						},
					},
				},
			},
		},
		sizeGroup = {
			order = 4,
			type = "group",
			name = L["Size"],
			disabled = function() return not E.bags end,
			args = {
				header = {
					order = 0,
					type = "header",
					name = L["Size"],
				},
				bagSize = {
					order = 2,
					type = 'range',
					name = L["Button Size (Bag)"],
					desc = L["The size of the individual buttons on the bag frame."],
					min = 15, max = 45, step = 1,
					set = function(info, value) E.db.bags[ info[#info] ] = value; B:Layout(); end,
				},
				bankSize = {
					order = 3,
					type = 'range',
					name = L["Button Size (Bank)"],
					desc = L["The size of the individual buttons on the bank frame."],
					min = 15, max = 45, step = 1,
					set = function(info, value) E.db.bags[ info[#info] ] = value; B:Layout(true) end,
				},
				bagWidth = {
					order = 4,
					type = 'range',
					name = L["Panel Width (Bags)"],
					desc = L["Adjust the width of the bag frame."],
					min = 150, max = 1400, step = 1,
					set = function(info, value) E.db.bags[ info[#info] ] = value; B:Layout();end,
				},
				bankWidth = {
					order = 5,
					type = 'range',
					name = L["Panel Width (Bank)"],
					desc = L["Adjust the width of the bank frame."],
					min = 150, max = 1400, step = 1,
					set = function(info, value) E.db.bags[ info[#info] ] = value; B:Layout(true) end,
				},
			},
		},
		bagBar = {
			order = 5,
			type = "group",
			name = L["Bag-Bar"],
			get = function(info) return E.db.bags.bagBar[ info[#info] ] end,
			set = function(info, value) E.db.bags.bagBar[ info[#info] ] = value; B:SizeAndPositionBagBar() end,
			args = {
				header = {
					order = 0,
					type = "header",
					name = L["Bag-Bar"],
				},
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Enable/Disable the Bag-Bar."],
					get = function(info) return E.private.bags.bagBar end,
					set = function(info, value) E.private.bags.bagBar = value; E:StaticPopup_Show("PRIVATE_RL") end
				},
				size = {
					order = 2,
					type = 'range',
					name = L["Button Size"],
					desc = L["Set the size of your bag buttons."],
					min = 24, max = 60, step = 1,
				},
				spacing = {
					order = 3,
					type = 'range',
					name = L["Button Spacing"],
					desc = L["The spacing between buttons."],
					min = 1, max = 10, step = 1,
				},
				showBackdrop = {
					order = 4,
					type = 'toggle',
					name = L["Backdrop"],
				},
				mouseover = {
					order = 5,
					name = L["Mouse Over"],
					desc = L["The frame is not shown unless you mouse over the frame."],
					type = "toggle",
				},
				sortDirection = {
					order = 6,
					type = 'select',
					name = L["Sort Direction"],
					desc = L["The direction that the bag frames will grow from the anchor."],
					values = {
						['ASCENDING'] = L["Ascending"],
						['DESCENDING'] = L["Descending"],
					},
				},
				growthDirection = {
					order = 7,
					type = 'select',
					name = L["Bar Direction"],
					desc = L["The direction that the bag frames be (Horizontal or Vertical)."],
					values = {
						['VERTICAL'] = L["Vertical"],
						['HORIZONTAL'] = L["Horizontal"],
					},
				},
			},
		},
		bagSortingGroup = {
			order = 6,
			type = "group",
			name = L["Bag Sorting"],
			args = {
				header = {
					order = 0,
					type = "header",
					name = L["Bag Sorting"],
				},
				description = {
					order = 1,
					type = "description",
					name = L["Items in this list or items that match any Search Syntax query in this list will be ignored when sorting. Separate each entry with a semicolon ;."],
				},
				ignoreItems = {
					order = 100,
					name = L["Ignore Items"],
					desc = L["IGNORE_ITEMS_DESC"],
					type = 'input',
					width = 'full',
					multiline = true,
					set = function(info, value) E.db.bags.ignoreItems = value; end,
				},
			},
		},
		search_syntax = {
			order = 7,
			type = "group",
			name = L["Search Syntax"],
			disabled = function() return not E.bags end,
			args = {
				header = {
					order = 0,
					type = "header",
					name = L["Search Syntax"],
				},
				text = {
					order = 1,
					type = "input",
					multiline = 26,
					width = "full",
					name = "",
					get = function(info) return L["SEARCH_SYNTAX_DESC"]; end,
					set = function(info, value) value = L["SEARCH_SYNTAX_DESC"]; end,
				},
			},
		},
	},
}
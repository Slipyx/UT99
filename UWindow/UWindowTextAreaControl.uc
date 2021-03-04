class UWindowTextAreaControl extends UWindowDialogControl;

var string TextArea[750];
var string Prompt;
var int Font;
var Font AbsoluteFont;
var int BufSize;
var int Head, Tail, Lines, VisibleRows;

var bool bCursor;
var bool bScrollable;
var bool bShowCaret;
var bool bScrollOnResize;

var UWindowVScrollBar VertSB;
var float LastDrawTime;

function Created()
{
	Super.Created();
	LastDrawTime = GetLevel().TimeSeconds;
}

function SetScrollable(bool newScrollable)
{
	bScrollable = newScrollable;
	if(newScrollable)
	{
		VertSB = UWindowVScrollbar(CreateWindow(class'UWindowVScrollbar', WinWidth-12, 0, 12, WinHeight));
		VertSB.bAlwaysOnTop = True;
	}
	else
	{
		if (VertSB != None)
		{
			VertSB.Close();
			VertSB = None;
		}
	}
}

function BeforePaint( Canvas C, float X, float Y )
{
	Super.BeforePaint(C, X, Y);

	if(VertSB != None)
	{
		VertSB.WinTop = 0;
		VertSB.WinHeight = WinHeight;
		VertSB.WinWidth = LookAndFeel.Size_ScrollbarWidth;
		VertSB.WinLeft = WinWidth - LookAndFeel.Size_ScrollbarWidth;
	}
}

function SetAbsoluteFont(Font F)
{
	AbsoluteFont = F;
}

function Paint( Canvas C, float X, float Y )
{
	local int i, j, Line;
	local int TempHead, TempTail;
	local float XL, YL;
	local float W, H;

	if(AbsoluteFont != None)
		C.Font = AbsoluteFont;
	else
		C.Font = Root.Fonts[Font];

	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 255;

	TextSize(C, "TEST", XL, YL);
	VisibleRows = WinHeight / YL;

	TempHead = Head;
	TempTail = Tail;
	Line = TempHead;
	TextArea[Line] = Prompt;

	if(Prompt == "")
	{
		Line--;
		if(Line < 0)
			Line += BufSize;
	}

	if(bScrollable)
	{
		if (VertSB.MaxPos - VertSB.Pos >= 0)
		{
			Line -= VertSB.MaxPos - VertSB.Pos;
			TempTail -= VertSB.MaxPos - VertSB.Pos;

			if(Line < 0)
				Line += BufSize;
			if(TempTail < 0)
				TempTail += BufSize;
		}
	}

	if(!bCursor)
	{
		bShowCaret = False;
	}
	else
	{
		if((GetLevel().TimeSeconds > LastDrawTime + 0.3) || (GetLevel().TimeSeconds < LastDrawTime))
		{
			LastDrawTime = GetLevel().TimeSeconds;
			bShowCaret = !bShowCaret;
		}
	}

	for(i=0; i<VisibleRows+1; i++)
	{
		ClipText(C, 2, WinHeight-YL*(i+1), TextArea[Line]);
		if(Line == Head && bShowCaret)
		{
			// Draw cursor..
			TextSize(C, TextArea[Line], W, H);
			ClipText(C, W, WinHeight-YL*(i+1), "|");
		}

		if(TempTail == Line)
			break;

		Line--;
		if(Line < 0)
			Line += BufSize;
	}
}

function AddText(string NewLine)
{
	local int i;

	TextArea[Head] = NewLine;
	Head = (Head + 1)%BufSize;

	if(Head == Tail)
		Tail = (Tail + 1)%BufSize;

	// Calculate lines for scrollbar.
	Lines = Head - Tail;
	if(Lines < 0)
		Lines += BufSize;

	if(bScrollable)
	{
		VertSB.SetRange(0, Lines, VisibleRows);
		VertSB.Pos = VertSB.MaxPos;
	}
}

function Resized()
{
	if(bScrollable)
	{
		VertSB.SetRange(0, Lines, VisibleRows);
		if(bScrollOnResize)
			VertSB.Pos = VertSB.MaxPos;
	}
}

function SetPrompt(string NewPrompt)
{
	Prompt = NewPrompt;
}

function Clear()
{
	TextArea[0] = "";
	Head = 0;
	Tail = 0;
}

function bool MouseWheelDown(float ScrollDelta)
{
	Super.MouseWheelDown(ScrollDelta);
	return true;
}

function bool MouseWheelUp(float ScrollDelta)
{
	Super.MouseWheelUp(ScrollDelta);
	if (VertSB != none)
	{
		VertSB.Scroll(int(ScrollDelta));
		return true;
	}
	return false;
}

defaultproperties
{
      TextArea(0)=""
      TextArea(1)=""
      TextArea(2)=""
      TextArea(3)=""
      TextArea(4)=""
      TextArea(5)=""
      TextArea(6)=""
      TextArea(7)=""
      TextArea(8)=""
      TextArea(9)=""
      TextArea(10)=""
      TextArea(11)=""
      TextArea(12)=""
      TextArea(13)=""
      TextArea(14)=""
      TextArea(15)=""
      TextArea(16)=""
      TextArea(17)=""
      TextArea(18)=""
      TextArea(19)=""
      TextArea(20)=""
      TextArea(21)=""
      TextArea(22)=""
      TextArea(23)=""
      TextArea(24)=""
      TextArea(25)=""
      TextArea(26)=""
      TextArea(27)=""
      TextArea(28)=""
      TextArea(29)=""
      TextArea(30)=""
      TextArea(31)=""
      TextArea(32)=""
      TextArea(33)=""
      TextArea(34)=""
      TextArea(35)=""
      TextArea(36)=""
      TextArea(37)=""
      TextArea(38)=""
      TextArea(39)=""
      TextArea(40)=""
      TextArea(41)=""
      TextArea(42)=""
      TextArea(43)=""
      TextArea(44)=""
      TextArea(45)=""
      TextArea(46)=""
      TextArea(47)=""
      TextArea(48)=""
      TextArea(49)=""
      TextArea(50)=""
      TextArea(51)=""
      TextArea(52)=""
      TextArea(53)=""
      TextArea(54)=""
      TextArea(55)=""
      TextArea(56)=""
      TextArea(57)=""
      TextArea(58)=""
      TextArea(59)=""
      TextArea(60)=""
      TextArea(61)=""
      TextArea(62)=""
      TextArea(63)=""
      TextArea(64)=""
      TextArea(65)=""
      TextArea(66)=""
      TextArea(67)=""
      TextArea(68)=""
      TextArea(69)=""
      TextArea(70)=""
      TextArea(71)=""
      TextArea(72)=""
      TextArea(73)=""
      TextArea(74)=""
      TextArea(75)=""
      TextArea(76)=""
      TextArea(77)=""
      TextArea(78)=""
      TextArea(79)=""
      TextArea(80)=""
      TextArea(81)=""
      TextArea(82)=""
      TextArea(83)=""
      TextArea(84)=""
      TextArea(85)=""
      TextArea(86)=""
      TextArea(87)=""
      TextArea(88)=""
      TextArea(89)=""
      TextArea(90)=""
      TextArea(91)=""
      TextArea(92)=""
      TextArea(93)=""
      TextArea(94)=""
      TextArea(95)=""
      TextArea(96)=""
      TextArea(97)=""
      TextArea(98)=""
      TextArea(99)=""
      TextArea(100)=""
      TextArea(101)=""
      TextArea(102)=""
      TextArea(103)=""
      TextArea(104)=""
      TextArea(105)=""
      TextArea(106)=""
      TextArea(107)=""
      TextArea(108)=""
      TextArea(109)=""
      TextArea(110)=""
      TextArea(111)=""
      TextArea(112)=""
      TextArea(113)=""
      TextArea(114)=""
      TextArea(115)=""
      TextArea(116)=""
      TextArea(117)=""
      TextArea(118)=""
      TextArea(119)=""
      TextArea(120)=""
      TextArea(121)=""
      TextArea(122)=""
      TextArea(123)=""
      TextArea(124)=""
      TextArea(125)=""
      TextArea(126)=""
      TextArea(127)=""
      TextArea(128)=""
      TextArea(129)=""
      TextArea(130)=""
      TextArea(131)=""
      TextArea(132)=""
      TextArea(133)=""
      TextArea(134)=""
      TextArea(135)=""
      TextArea(136)=""
      TextArea(137)=""
      TextArea(138)=""
      TextArea(139)=""
      TextArea(140)=""
      TextArea(141)=""
      TextArea(142)=""
      TextArea(143)=""
      TextArea(144)=""
      TextArea(145)=""
      TextArea(146)=""
      TextArea(147)=""
      TextArea(148)=""
      TextArea(149)=""
      TextArea(150)=""
      TextArea(151)=""
      TextArea(152)=""
      TextArea(153)=""
      TextArea(154)=""
      TextArea(155)=""
      TextArea(156)=""
      TextArea(157)=""
      TextArea(158)=""
      TextArea(159)=""
      TextArea(160)=""
      TextArea(161)=""
      TextArea(162)=""
      TextArea(163)=""
      TextArea(164)=""
      TextArea(165)=""
      TextArea(166)=""
      TextArea(167)=""
      TextArea(168)=""
      TextArea(169)=""
      TextArea(170)=""
      TextArea(171)=""
      TextArea(172)=""
      TextArea(173)=""
      TextArea(174)=""
      TextArea(175)=""
      TextArea(176)=""
      TextArea(177)=""
      TextArea(178)=""
      TextArea(179)=""
      TextArea(180)=""
      TextArea(181)=""
      TextArea(182)=""
      TextArea(183)=""
      TextArea(184)=""
      TextArea(185)=""
      TextArea(186)=""
      TextArea(187)=""
      TextArea(188)=""
      TextArea(189)=""
      TextArea(190)=""
      TextArea(191)=""
      TextArea(192)=""
      TextArea(193)=""
      TextArea(194)=""
      TextArea(195)=""
      TextArea(196)=""
      TextArea(197)=""
      TextArea(198)=""
      TextArea(199)=""
      TextArea(200)=""
      TextArea(201)=""
      TextArea(202)=""
      TextArea(203)=""
      TextArea(204)=""
      TextArea(205)=""
      TextArea(206)=""
      TextArea(207)=""
      TextArea(208)=""
      TextArea(209)=""
      TextArea(210)=""
      TextArea(211)=""
      TextArea(212)=""
      TextArea(213)=""
      TextArea(214)=""
      TextArea(215)=""
      TextArea(216)=""
      TextArea(217)=""
      TextArea(218)=""
      TextArea(219)=""
      TextArea(220)=""
      TextArea(221)=""
      TextArea(222)=""
      TextArea(223)=""
      TextArea(224)=""
      TextArea(225)=""
      TextArea(226)=""
      TextArea(227)=""
      TextArea(228)=""
      TextArea(229)=""
      TextArea(230)=""
      TextArea(231)=""
      TextArea(232)=""
      TextArea(233)=""
      TextArea(234)=""
      TextArea(235)=""
      TextArea(236)=""
      TextArea(237)=""
      TextArea(238)=""
      TextArea(239)=""
      TextArea(240)=""
      TextArea(241)=""
      TextArea(242)=""
      TextArea(243)=""
      TextArea(244)=""
      TextArea(245)=""
      TextArea(246)=""
      TextArea(247)=""
      TextArea(248)=""
      TextArea(249)=""
      TextArea(250)=""
      TextArea(251)=""
      TextArea(252)=""
      TextArea(253)=""
      TextArea(254)=""
      TextArea(255)=""
      TextArea(256)=""
      TextArea(257)=""
      TextArea(258)=""
      TextArea(259)=""
      TextArea(260)=""
      TextArea(261)=""
      TextArea(262)=""
      TextArea(263)=""
      TextArea(264)=""
      TextArea(265)=""
      TextArea(266)=""
      TextArea(267)=""
      TextArea(268)=""
      TextArea(269)=""
      TextArea(270)=""
      TextArea(271)=""
      TextArea(272)=""
      TextArea(273)=""
      TextArea(274)=""
      TextArea(275)=""
      TextArea(276)=""
      TextArea(277)=""
      TextArea(278)=""
      TextArea(279)=""
      TextArea(280)=""
      TextArea(281)=""
      TextArea(282)=""
      TextArea(283)=""
      TextArea(284)=""
      TextArea(285)=""
      TextArea(286)=""
      TextArea(287)=""
      TextArea(288)=""
      TextArea(289)=""
      TextArea(290)=""
      TextArea(291)=""
      TextArea(292)=""
      TextArea(293)=""
      TextArea(294)=""
      TextArea(295)=""
      TextArea(296)=""
      TextArea(297)=""
      TextArea(298)=""
      TextArea(299)=""
      TextArea(300)=""
      TextArea(301)=""
      TextArea(302)=""
      TextArea(303)=""
      TextArea(304)=""
      TextArea(305)=""
      TextArea(306)=""
      TextArea(307)=""
      TextArea(308)=""
      TextArea(309)=""
      TextArea(310)=""
      TextArea(311)=""
      TextArea(312)=""
      TextArea(313)=""
      TextArea(314)=""
      TextArea(315)=""
      TextArea(316)=""
      TextArea(317)=""
      TextArea(318)=""
      TextArea(319)=""
      TextArea(320)=""
      TextArea(321)=""
      TextArea(322)=""
      TextArea(323)=""
      TextArea(324)=""
      TextArea(325)=""
      TextArea(326)=""
      TextArea(327)=""
      TextArea(328)=""
      TextArea(329)=""
      TextArea(330)=""
      TextArea(331)=""
      TextArea(332)=""
      TextArea(333)=""
      TextArea(334)=""
      TextArea(335)=""
      TextArea(336)=""
      TextArea(337)=""
      TextArea(338)=""
      TextArea(339)=""
      TextArea(340)=""
      TextArea(341)=""
      TextArea(342)=""
      TextArea(343)=""
      TextArea(344)=""
      TextArea(345)=""
      TextArea(346)=""
      TextArea(347)=""
      TextArea(348)=""
      TextArea(349)=""
      TextArea(350)=""
      TextArea(351)=""
      TextArea(352)=""
      TextArea(353)=""
      TextArea(354)=""
      TextArea(355)=""
      TextArea(356)=""
      TextArea(357)=""
      TextArea(358)=""
      TextArea(359)=""
      TextArea(360)=""
      TextArea(361)=""
      TextArea(362)=""
      TextArea(363)=""
      TextArea(364)=""
      TextArea(365)=""
      TextArea(366)=""
      TextArea(367)=""
      TextArea(368)=""
      TextArea(369)=""
      TextArea(370)=""
      TextArea(371)=""
      TextArea(372)=""
      TextArea(373)=""
      TextArea(374)=""
      TextArea(375)=""
      TextArea(376)=""
      TextArea(377)=""
      TextArea(378)=""
      TextArea(379)=""
      TextArea(380)=""
      TextArea(381)=""
      TextArea(382)=""
      TextArea(383)=""
      TextArea(384)=""
      TextArea(385)=""
      TextArea(386)=""
      TextArea(387)=""
      TextArea(388)=""
      TextArea(389)=""
      TextArea(390)=""
      TextArea(391)=""
      TextArea(392)=""
      TextArea(393)=""
      TextArea(394)=""
      TextArea(395)=""
      TextArea(396)=""
      TextArea(397)=""
      TextArea(398)=""
      TextArea(399)=""
      TextArea(400)=""
      TextArea(401)=""
      TextArea(402)=""
      TextArea(403)=""
      TextArea(404)=""
      TextArea(405)=""
      TextArea(406)=""
      TextArea(407)=""
      TextArea(408)=""
      TextArea(409)=""
      TextArea(410)=""
      TextArea(411)=""
      TextArea(412)=""
      TextArea(413)=""
      TextArea(414)=""
      TextArea(415)=""
      TextArea(416)=""
      TextArea(417)=""
      TextArea(418)=""
      TextArea(419)=""
      TextArea(420)=""
      TextArea(421)=""
      TextArea(422)=""
      TextArea(423)=""
      TextArea(424)=""
      TextArea(425)=""
      TextArea(426)=""
      TextArea(427)=""
      TextArea(428)=""
      TextArea(429)=""
      TextArea(430)=""
      TextArea(431)=""
      TextArea(432)=""
      TextArea(433)=""
      TextArea(434)=""
      TextArea(435)=""
      TextArea(436)=""
      TextArea(437)=""
      TextArea(438)=""
      TextArea(439)=""
      TextArea(440)=""
      TextArea(441)=""
      TextArea(442)=""
      TextArea(443)=""
      TextArea(444)=""
      TextArea(445)=""
      TextArea(446)=""
      TextArea(447)=""
      TextArea(448)=""
      TextArea(449)=""
      TextArea(450)=""
      TextArea(451)=""
      TextArea(452)=""
      TextArea(453)=""
      TextArea(454)=""
      TextArea(455)=""
      TextArea(456)=""
      TextArea(457)=""
      TextArea(458)=""
      TextArea(459)=""
      TextArea(460)=""
      TextArea(461)=""
      TextArea(462)=""
      TextArea(463)=""
      TextArea(464)=""
      TextArea(465)=""
      TextArea(466)=""
      TextArea(467)=""
      TextArea(468)=""
      TextArea(469)=""
      TextArea(470)=""
      TextArea(471)=""
      TextArea(472)=""
      TextArea(473)=""
      TextArea(474)=""
      TextArea(475)=""
      TextArea(476)=""
      TextArea(477)=""
      TextArea(478)=""
      TextArea(479)=""
      TextArea(480)=""
      TextArea(481)=""
      TextArea(482)=""
      TextArea(483)=""
      TextArea(484)=""
      TextArea(485)=""
      TextArea(486)=""
      TextArea(487)=""
      TextArea(488)=""
      TextArea(489)=""
      TextArea(490)=""
      TextArea(491)=""
      TextArea(492)=""
      TextArea(493)=""
      TextArea(494)=""
      TextArea(495)=""
      TextArea(496)=""
      TextArea(497)=""
      TextArea(498)=""
      TextArea(499)=""
      TextArea(500)=""
      TextArea(501)=""
      TextArea(502)=""
      TextArea(503)=""
      TextArea(504)=""
      TextArea(505)=""
      TextArea(506)=""
      TextArea(507)=""
      TextArea(508)=""
      TextArea(509)=""
      TextArea(510)=""
      TextArea(511)=""
      TextArea(512)=""
      TextArea(513)=""
      TextArea(514)=""
      TextArea(515)=""
      TextArea(516)=""
      TextArea(517)=""
      TextArea(518)=""
      TextArea(519)=""
      TextArea(520)=""
      TextArea(521)=""
      TextArea(522)=""
      TextArea(523)=""
      TextArea(524)=""
      TextArea(525)=""
      TextArea(526)=""
      TextArea(527)=""
      TextArea(528)=""
      TextArea(529)=""
      TextArea(530)=""
      TextArea(531)=""
      TextArea(532)=""
      TextArea(533)=""
      TextArea(534)=""
      TextArea(535)=""
      TextArea(536)=""
      TextArea(537)=""
      TextArea(538)=""
      TextArea(539)=""
      TextArea(540)=""
      TextArea(541)=""
      TextArea(542)=""
      TextArea(543)=""
      TextArea(544)=""
      TextArea(545)=""
      TextArea(546)=""
      TextArea(547)=""
      TextArea(548)=""
      TextArea(549)=""
      TextArea(550)=""
      TextArea(551)=""
      TextArea(552)=""
      TextArea(553)=""
      TextArea(554)=""
      TextArea(555)=""
      TextArea(556)=""
      TextArea(557)=""
      TextArea(558)=""
      TextArea(559)=""
      TextArea(560)=""
      TextArea(561)=""
      TextArea(562)=""
      TextArea(563)=""
      TextArea(564)=""
      TextArea(565)=""
      TextArea(566)=""
      TextArea(567)=""
      TextArea(568)=""
      TextArea(569)=""
      TextArea(570)=""
      TextArea(571)=""
      TextArea(572)=""
      TextArea(573)=""
      TextArea(574)=""
      TextArea(575)=""
      TextArea(576)=""
      TextArea(577)=""
      TextArea(578)=""
      TextArea(579)=""
      TextArea(580)=""
      TextArea(581)=""
      TextArea(582)=""
      TextArea(583)=""
      TextArea(584)=""
      TextArea(585)=""
      TextArea(586)=""
      TextArea(587)=""
      TextArea(588)=""
      TextArea(589)=""
      TextArea(590)=""
      TextArea(591)=""
      TextArea(592)=""
      TextArea(593)=""
      TextArea(594)=""
      TextArea(595)=""
      TextArea(596)=""
      TextArea(597)=""
      TextArea(598)=""
      TextArea(599)=""
      TextArea(600)=""
      TextArea(601)=""
      TextArea(602)=""
      TextArea(603)=""
      TextArea(604)=""
      TextArea(605)=""
      TextArea(606)=""
      TextArea(607)=""
      TextArea(608)=""
      TextArea(609)=""
      TextArea(610)=""
      TextArea(611)=""
      TextArea(612)=""
      TextArea(613)=""
      TextArea(614)=""
      TextArea(615)=""
      TextArea(616)=""
      TextArea(617)=""
      TextArea(618)=""
      TextArea(619)=""
      TextArea(620)=""
      TextArea(621)=""
      TextArea(622)=""
      TextArea(623)=""
      TextArea(624)=""
      TextArea(625)=""
      TextArea(626)=""
      TextArea(627)=""
      TextArea(628)=""
      TextArea(629)=""
      TextArea(630)=""
      TextArea(631)=""
      TextArea(632)=""
      TextArea(633)=""
      TextArea(634)=""
      TextArea(635)=""
      TextArea(636)=""
      TextArea(637)=""
      TextArea(638)=""
      TextArea(639)=""
      TextArea(640)=""
      TextArea(641)=""
      TextArea(642)=""
      TextArea(643)=""
      TextArea(644)=""
      TextArea(645)=""
      TextArea(646)=""
      TextArea(647)=""
      TextArea(648)=""
      TextArea(649)=""
      TextArea(650)=""
      TextArea(651)=""
      TextArea(652)=""
      TextArea(653)=""
      TextArea(654)=""
      TextArea(655)=""
      TextArea(656)=""
      TextArea(657)=""
      TextArea(658)=""
      TextArea(659)=""
      TextArea(660)=""
      TextArea(661)=""
      TextArea(662)=""
      TextArea(663)=""
      TextArea(664)=""
      TextArea(665)=""
      TextArea(666)=""
      TextArea(667)=""
      TextArea(668)=""
      TextArea(669)=""
      TextArea(670)=""
      TextArea(671)=""
      TextArea(672)=""
      TextArea(673)=""
      TextArea(674)=""
      TextArea(675)=""
      TextArea(676)=""
      TextArea(677)=""
      TextArea(678)=""
      TextArea(679)=""
      TextArea(680)=""
      TextArea(681)=""
      TextArea(682)=""
      TextArea(683)=""
      TextArea(684)=""
      TextArea(685)=""
      TextArea(686)=""
      TextArea(687)=""
      TextArea(688)=""
      TextArea(689)=""
      TextArea(690)=""
      TextArea(691)=""
      TextArea(692)=""
      TextArea(693)=""
      TextArea(694)=""
      TextArea(695)=""
      TextArea(696)=""
      TextArea(697)=""
      TextArea(698)=""
      TextArea(699)=""
      TextArea(700)=""
      TextArea(701)=""
      TextArea(702)=""
      TextArea(703)=""
      TextArea(704)=""
      TextArea(705)=""
      TextArea(706)=""
      TextArea(707)=""
      TextArea(708)=""
      TextArea(709)=""
      TextArea(710)=""
      TextArea(711)=""
      TextArea(712)=""
      TextArea(713)=""
      TextArea(714)=""
      TextArea(715)=""
      TextArea(716)=""
      TextArea(717)=""
      TextArea(718)=""
      TextArea(719)=""
      TextArea(720)=""
      TextArea(721)=""
      TextArea(722)=""
      TextArea(723)=""
      TextArea(724)=""
      TextArea(725)=""
      TextArea(726)=""
      TextArea(727)=""
      TextArea(728)=""
      TextArea(729)=""
      TextArea(730)=""
      TextArea(731)=""
      TextArea(732)=""
      TextArea(733)=""
      TextArea(734)=""
      TextArea(735)=""
      TextArea(736)=""
      TextArea(737)=""
      TextArea(738)=""
      TextArea(739)=""
      TextArea(740)=""
      TextArea(741)=""
      TextArea(742)=""
      TextArea(743)=""
      TextArea(744)=""
      TextArea(745)=""
      TextArea(746)=""
      TextArea(747)=""
      TextArea(748)=""
      TextArea(749)=""
      Prompt=""
      Font=0
      AbsoluteFont=None
      BufSize=750
      Head=0
      Tail=0
      Lines=0
      VisibleRows=0
      bCursor=False
      bScrollable=False
      bShowCaret=False
      bScrollOnResize=True
      VertSB=None
      LastDrawTime=0.000000
}

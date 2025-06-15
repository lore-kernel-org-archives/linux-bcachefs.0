Received: from CY4PR02CU008.outbound.protection.outlook.com (mail-westcentralusazon11021123.outbound.protection.outlook.com [40.93.199.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05297E1
	for <linux-bcachefs@vger.kernel.org>; Sun, 15 Jun 2025 06:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.199.123
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749967560; cv=fail; b=O5OaXW0nwRK86zK/o8LVVm4tV+jEZziJCoffR22zSpovfmIkZUvwbmDmUECxQRwBqm17rnoyVy1J4cMEBv9c20azQczHxs2y/+5IDu0dmvqWA+ftNfFnXksF3xw8RCRQc69kWiz6UjousR0m5aKGJBcFekWxLO+gbZHkU2pkiv0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749967560; c=relaxed/simple;
	bh=jzSE7lcxnd8QDwrGY87SXTabp5dLR38pzlX5qzkPsmw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tUdzIV6iOONN4jVRZuqE/1DtLnzaxZq5pul4N1+81fWtW0/V9TLDuvcXTteqtd7hfK/u3AIQlWAZtuNoYCivv2pc61Kg4M0PxYB+T5h8K5DF3yL6PyfTKA/stZM9pFNdnvr1eeCfgsWkimUrE+K9W/yioBthbNlZ0UuVA1LnvAg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aaronfriel.com; spf=pass smtp.mailfrom=aaronfriel.com; dkim=pass (1024-bit key) header.d=FRIELTEK.onmicrosoft.com header.i=@FRIELTEK.onmicrosoft.com header.b=XO95HuRh; arc=fail smtp.client-ip=40.93.199.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aaronfriel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aaronfriel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=FRIELTEK.onmicrosoft.com header.i=@FRIELTEK.onmicrosoft.com header.b="XO95HuRh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WMgM7UqR9CFZjOKWDWwB7uYZkVFBprM5YvhkW+0OIfsPHwMjsMT2xWLVJn1ewJ21OfgJt35NPe9Jzxi1ZA6dqXFrY4toOpmXDyb91jB0ZQU7UIePHzrz2fECoRUg7nQFR8kMd2KFx27mFDczDgCq2yQSXmM8vVp1md+mVT/kgxRZ1TR2sSEtkKGU19WGO1IwOuv/FOcWuAiNwIsWlKJo8li+SIiSvCgZGy8cLlRfXIomXb2dbEfuvRD3bxK2DImIK1HEJurTuUvwLGQ8ceDf9aJsrB6gwXmKzZr19UslYT4ywcWWm/6wLW6ARSFfKxUEdYWmyVLEni4MAshzFV9sOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jzSE7lcxnd8QDwrGY87SXTabp5dLR38pzlX5qzkPsmw=;
 b=lTy1xfsovDQqfNfIig0LvYUFsBVmyVSDEi0rFWiTKKhyJPmAs+coULyCMeHHQHGY2jPlEceMcB4cKL+eY+Qbh0UZ36yLSFk/CRvk+xtqh2As5feikW6p4dSEw58Wf2FA9+htaynyrP43FCcLYn7lOe7fC4V0RwKPiUdZYopMYjP6cwW7BQdweUtrVrvylsta6Fg0jS0zP7LT7EgXJeBgzFfpd8+8JnVLFsuzimiGUqazwN1jmI1gwcEACGmTa8+Oy+npsQTrVw/vquk5OyAwV6I3Wcvw8OCRSoh5W9o+Jf8gl6eknem6b0zhDIHmzaURB7sYa/rWguT06bRHEkqouA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aaronfriel.com; dmarc=pass action=none
 header.from=aaronfriel.com; dkim=pass header.d=aaronfriel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=FRIELTEK.onmicrosoft.com; s=selector2-FRIELTEK-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jzSE7lcxnd8QDwrGY87SXTabp5dLR38pzlX5qzkPsmw=;
 b=XO95HuRhXwy88H6NgYlD9Qx2c6Ill3wgzGL5iGOnsaKvc/8NNa4KWXcWKn+g39yhT3v/O9C0U2KaYdYcN7s497FsmjPPYJwhL9HvUYyKRsw0wa1b0CXBQ65FOCuXawEGJ5yKbKApll9l19Hmf+YycfAfbW3TV+qbJxufEcM1RdQ=
Received: from MW4PR05MB9993.namprd05.prod.outlook.com (2603:10b6:303:1ef::21)
 by SJ2PR05MB10355.namprd05.prod.outlook.com (2603:10b6:a03:55c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.29; Sun, 15 Jun
 2025 06:05:53 +0000
Received: from MW4PR05MB9993.namprd05.prod.outlook.com
 ([fe80::da:f56d:ad76:326e]) by MW4PR05MB9993.namprd05.prod.outlook.com
 ([fe80::da:f56d:ad76:326e%4]) with mapi id 15.20.8835.027; Sun, 15 Jun 2025
 06:05:53 +0000
From: Aaron Friel <mayreply@aaronfriel.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: Issues setting durability on new devices in bcachefs
Thread-Topic: Issues setting durability on new devices in bcachefs
Thread-Index: AQHb3aG7BcdLvKRiWEq49GHsrqA8x7QDmi8AgAAgvto=
Date: Sun, 15 Jun 2025 06:05:52 +0000
Message-ID:
 <MW4PR05MB9993BFE56AEF738F894D5586B571A@MW4PR05MB9993.namprd05.prod.outlook.com>
References:
 <MW4PR05MB99934C43FB32313C921D7765B571A@MW4PR05MB9993.namprd05.prod.outlook.com>
 <qj5wzirldvxhd6om54mnzenq52hdh25zbvzhtirdgumo4zwh5o@hwccwflcdvyo>
In-Reply-To: <qj5wzirldvxhd6om54mnzenq52hdh25zbvzhtirdgumo4zwh5o@hwccwflcdvyo>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=aaronfriel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR05MB9993:EE_|SJ2PR05MB10355:EE_
x-ms-office365-filtering-correlation-id: 5505ad4c-576a-4864-8e14-08ddabd2af62
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?hipstq6yy3jFxKkhx7iL5DcYnt2rDxxqVCPN5/R07R1hXXEFgmUzyw8VDb?=
 =?iso-8859-1?Q?9tXXuqPtE6uWOJh0b/UXGcXLSWU97ai0P6nGZweLxVSrBIZ2NOnBC5dbES?=
 =?iso-8859-1?Q?uKv+7N3wtl7D53POOro40o08u1vNoYOQb0Y6kB1seRKB/Q58TVuoIYbq+n?=
 =?iso-8859-1?Q?wUzitsDhT5OhhrDP0VqktBMJ+9nfwcJ+mS3649ISVnNnnusiYV6SVcfJ8n?=
 =?iso-8859-1?Q?N4ibIyyol+yHMJGzINbylxRX6/dyBzTR/EHIWFZKQ+fkE85gKcfWO3Hhtw?=
 =?iso-8859-1?Q?JlXCOm+D8xXwo4t66r/YYVPVmRePZf4XkeO+hslTs06j/BjN+Wn7y9JiG+?=
 =?iso-8859-1?Q?6kJYO1rA4RnLtByD2kxzWtAhcubA/PGqn40Z5DudYdXCnY029FY6zxVikn?=
 =?iso-8859-1?Q?z8Xo2eLwKYD/HNwD46kzGavw1G99ZhbXbW9e7jXFVdbtutGtsrnI03+o1R?=
 =?iso-8859-1?Q?Dd0UkmesCkNGyU5qa3RUYLMd4t3JpZ5i3xIcKv59m2mlxtdn83A9xa8sCg?=
 =?iso-8859-1?Q?hYgjcgZsvFWMHF4wx5for4NDc4VXvG1tH7Kkoxrak6lR7jpAhvYPHHGNbm?=
 =?iso-8859-1?Q?Me2jrQ6uWE13Jrx+cZKNEeszymNslpgB1UJM6zwSWRJacX9hyZGNF163qm?=
 =?iso-8859-1?Q?pRjxWVpkNnkGoFVQm3mX5fg3M5DKiwjNkjkA1NJhDhBuiKaFApg7Jv9kQn?=
 =?iso-8859-1?Q?wXY9lbVKmCqAZofLe3euO8AKmU6i/Ot++kjMFIFoy5+B6TCtZcFd3odan1?=
 =?iso-8859-1?Q?srPeZgIvY+sM3+gcS4i9o2KSdpr5Drbuhl2qc5W308gv+KBik6BZCa+syo?=
 =?iso-8859-1?Q?t87aID/AV9vsPlbkQ1x5WDIJrJFiAAR8bL53wLD2+AN80/EJxJYFy6PMHt?=
 =?iso-8859-1?Q?zcxLQX8BBevOBYnmS4BLH78vdAbdNv5/k9qMzzs7qLbXivTL6bSEos2oI9?=
 =?iso-8859-1?Q?n2c985BmYfm7jX+nbWHDACdrtKf4/j2+FI0TeoBtPSLhdvT7qsj/Q8wOoc?=
 =?iso-8859-1?Q?/xQXEFIsTmUzHGfE0D+UuAINAwg4PnLq/sSkuQJINtVXUrdDkdfbcEvvLP?=
 =?iso-8859-1?Q?uiwStxuwPw1eGV1wCQa2pHN+kVFlCY5lcBTunco5SZTRoE96GWoz9DNPVX?=
 =?iso-8859-1?Q?6nCV3iQfpmlfUEMbxqikv7vSQkagxG3ppUhnHONO+XwOdgEwOeX51MennQ?=
 =?iso-8859-1?Q?Cx1/diu+Twl+nfyNo2lsJWBH13m8B61HCmzQZuNOR7JrhHuGwMNCn3Oiwz?=
 =?iso-8859-1?Q?3StGV9dJ9Ejw8aFmW7pr0aSeXkLxts7u9G6y6KpniECasn5L8JADNrVPFP?=
 =?iso-8859-1?Q?6U0py9OROmQNmQyORI621ZMOrVwk526ttPbqA8wr4x0uJtTyV3GeOwyV2J?=
 =?iso-8859-1?Q?srMmO/QdkXSbMSE+LPbQFtaxQac6ANhp9qG9bXCyJEaPGUA0RlCnKmOe5q?=
 =?iso-8859-1?Q?IetSLajrpTOOuTPn0RK1d42Ye9K5JntJ0tzyjs30TeWZ78p3hgS62ISeie?=
 =?iso-8859-1?Q?bgdAYaWUUSU6eQVHScIdh011iFYH6HWwU0QBXacsslpQ=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR05MB9993.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?Bl6lzrOOkhaSx+/7LXgfoL+ps2nRRUredwa60YAE8Td30sCp2fCbLsHITV?=
 =?iso-8859-1?Q?DbOPWzO84Myw62A3tiBbkn57etccq7RiIp1c1FpFZ793RDR3hQat4ApAa3?=
 =?iso-8859-1?Q?hJvctkeFTgA+q5/i4i2EBb0m73Q3duIMHILOBWjAgM9v/QFpBKaQUXieYl?=
 =?iso-8859-1?Q?iXjNn4uDmjuUqjXi/U+cHqAB30z/8sWi361Tp/IuUZNaUzpAKEsGKNv4Tt?=
 =?iso-8859-1?Q?wOGHDSFpzzHgNLOHqYrghOVkG2uY7HGphj19Zo4E9vsJY/HTFEheQCQZed?=
 =?iso-8859-1?Q?wWxRhodfUOrsQxZMFL/9RXjlsLD/hLBHDaGrQOqIupqhc2UsbhFXNUfBWt?=
 =?iso-8859-1?Q?S5WvlFEwuTiJWfZc0ImuJVGfbReXJ/ePWqZNhyD1tGKVmozh2ptao+F9mx?=
 =?iso-8859-1?Q?RdirmKq/pmT6/5ZgGVoWlG//S1I4Rgc2OOKtbFhWxdes8g0q6yhvpnQ/3f?=
 =?iso-8859-1?Q?BdYVNNvEt5SxdAEHbfPGca0Xh2zZ4DTD15Qcbgoj9DqSQpnr5MBz7vGRXc?=
 =?iso-8859-1?Q?u4vQkkJbVnBxZsYnYkkjRjAx/WOKrXExjjCWGo5ZeznDLARePNJ9nQ8BLt?=
 =?iso-8859-1?Q?SyzSQh7fBsKrtovwjfSdKcCO2TOijxJFuXazEYuFxClHNpXn0boZyTq1bs?=
 =?iso-8859-1?Q?hDLmH2D6KV9cfKcdP/h7KCQ0kQmLgXP4GIZrr7Ex5RYpWk1GlmUC68v3R5?=
 =?iso-8859-1?Q?8lG6CIgArZgo1SyLOniUowY47aOW/iz1q+F22j8FPmpoJD8W7qo/gS+LLv?=
 =?iso-8859-1?Q?+7kLMxj+gCTORfxkwGLRSIeG6uuDZE48y86eWcoc/efcGF3eFQxFQ8JSgW?=
 =?iso-8859-1?Q?m7oaI8CURkHxIB+YWZKq8K7AFWll7aqOTA/Nydu6+vMybEvCjMa9iPs5fg?=
 =?iso-8859-1?Q?xRpLHzcnuOYK4NO5tAgDLxQvygRoshqwB5SsNumfByZveJ1qCRzLjzsAJz?=
 =?iso-8859-1?Q?PkUbreFg+MpCRWqSQEi/ppTyI5EtUtkfIcZgJZgS1mZieTmVABzDHgaspW?=
 =?iso-8859-1?Q?7AtPIpGkq3najTUrhUs1rwpwNW/yzC9t2bnsKPlwC+gbXaw16cP05LnYLD?=
 =?iso-8859-1?Q?8qPwV62Q2CCe9hE86vkpW+WAdQ0524yGD3sm2NEjhv3hoqC+GJFRqt1y9K?=
 =?iso-8859-1?Q?LbljmKi7SGh3vH6rnWqeUT4QF+JaFz5SlMNc3sTb79VvuziZilDZmdrfGm?=
 =?iso-8859-1?Q?aORnfX4DXWT87gDDqrzWG9O3BWRM8eiXCc1SRCw/mhDozCFQHF1lSTzKjX?=
 =?iso-8859-1?Q?u73iwmeGTiOkw9LVWzOrXF6jgCjC73db0hxsM5FrTufrhZion6ewXGmlqU?=
 =?iso-8859-1?Q?gRAfE5qIwn9msO6kwZanAE/BJ1CtWiZfT+vDnzlX4FmDWoYg5CbQpNL+Gn?=
 =?iso-8859-1?Q?qW+OKUme9Kuxx6c9A/HCbUzaX76oUT14djRwi4KejppjmEet9xCwYaXDxr?=
 =?iso-8859-1?Q?XH1pLn5I6epGPfzM8ppkAVSAakY2RapfpmfjPY5MhltLncpVL0K6rc07wp?=
 =?iso-8859-1?Q?k1KPv9+USE/ix10PfcyfQ4YgUsGHJJ+3376t2gqcPyb6ioR/dJi0fnn2xi?=
 =?iso-8859-1?Q?qX/r+ajY8XD4I00uT8cYoaFCY5lPLzwmoCyx3pCmvNuRtmyMXYgYfbTSSK?=
 =?iso-8859-1?Q?sldbPICrXEZnbQ4giWphrSj1m96bpNMOFb?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: aaronfriel.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR05MB9993.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5505ad4c-576a-4864-8e14-08ddabd2af62
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2025 06:05:52.9816
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd1ff30b-4659-4018-98d4-c7ec5f672515
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f4xp15ERrdGYUGG4pWg/d8v671GVSZABwGEeeVeKPQ6Uuu8oDnJ7ISKv4ckLYjuZLM2BRyu0X33LpvtXakewCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR05MB10355

I'm looking to see if I can submit a patch to fix this, but it seems like t=
he durability bit field for devices may be only 2 bits, is that right?=0A=
=0A=
--- =0A=
=0A=
previous thread follows (sorry my mail client doesn't quote everything in t=
he usual mailing list style. If that's preferable let me know, but it's a c=
hore to format things correctly using my phone=0A=
=0A=
---=0A=
=0A=
> Hey Kent,=0A=
>=0A=
> I reported an issue on Reddit with bcachefs, attempting to set durability=
 > 1 on an additional device in the pool. Not having the best luck!=0A=
>=0A=
> https://www.reddit.com/r/bcachefs/comments/1lbpxvs/unable_to_set_durabili=
ty_on_new_devices_segfault/=0A=
>=0A=
> It looks like Fedora 42 is still on 6.14, so maybe this is fixed with=0A=
> a kernel bump or a new version of the tools? I hope so - would really=0A=
> like to make use of it for a tiered array.=0A=
=0A=
It's a tools bug. Check if it's still happening with the latest tools,=0A=
and if it is I'll have a look.=0A=
=0A=
Durability needs to be changed via sysfs, we don't have a commandline=0A=
tool for setting device options (and I suppose we should, for=0A=
consistency).=0A=
=0A=
Also, reddit's been working out surprisingly well for bug reports, since=0A=
it's the place that gets the most engagement from users. Bug tracker is=0A=
still good for things that need to be filed so they don't get lost, but=0A=
it's been a pleasant surprise :)=

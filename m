Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2079.outbound.protection.outlook.com [40.107.22.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194EC1C5D77
	for <linux-bcachefs@vger.kernel.org>; Thu, 22 May 2025 06:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747895956; cv=fail; b=V1cb5F02R/b+tYNCPKwtNHgBu3xd9SvO67/w64aredMaQ68FZAYZyk1mnWSnERcORYic4fDyMJ8HxrnFUiVykuDvToEQMZvkohwXbi2FrebFeWYiCHj7MQZRNmQ0ObxEzVvkFjtfS3lWEEEZewEOgokMwN3q6hBfwd3b0MF6Ddo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747895956; c=relaxed/simple;
	bh=Z5I2kohxSlMkgLWsF7Vz79P3x1IsQJSuLjhtzfmwAro=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=V7uCfpw54jhrS2E1AyBsryQy6CiCZ1mvvJzuxA94K4oIkY/iIUFFpXm5G3R5DqCk2S9sFQDv0xZw3p/eKPefyTn0id2cCPd/vfbLHHgdYag3FzSoYmGgApb29GXV8lT3RgQCidQ6TyBQRIJhRcbqa26jEM7re6YGYlwftmLZjdE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=n2jXlHVl; arc=fail smtp.client-ip=40.107.22.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="n2jXlHVl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MZuzEsLoD8ZIr6kU0mRt240aZmc7bOqWn9dgP3lb4eKZc8xq63RhT9puqj2GRbgGiRuUWwr4deR0u92g0JCnFEBBzEi6k/OgT+Rd9RKWaBfrzWLgUkWmVDJvR4vVEoBT3XCXC3megNd89K1Du2xvDm+onnwSF8PWrwXGhubq8dxfJV7Zx/UYv5e4kMYkKUKNmb6Zo4FjqgF2jhuNmC2NP7RWCf8+nJZZk+M0Qq6gf9w8BQBlMAAkQGJa3G2//WRl8/tTeYO5A6HutWCaEGCYDMraQBvN6utOMK8JoVadW7tLzyocO7vbSTY8yqf5w4Qevori+O4mm/54aNMCfc1bQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AgEsjcTGgunJSPxogmF+1QI7Bda+nKwKoMw8qsnVQss=;
 b=aLkQ4Mch03qcVGj77LRvOsi/tL9p+IcYbqX39RoZvYxyBkAFooxw/k1vo4atYiyP8jrL2Ul/J10apRKttfbXlTXssDXlekT9pYpnodzOaDa04ZC4RMAn5mM9d+IwMw+4h9JDImlRSNNO6/gY+aTIIoLUJ1h+R05K7oSHlGyO9omaMf3BZxwQwx52tb9zX2e1ssYWzLpvp+X0ETMJbhsVm/I8t8opaqrUJuUV6Z6rZV0Ww9wikLBGyBWYQykC0upgfSBc2yd08awaKxHWmrcY87LdppK1F4/7PgzkDcTXFypq2ypifrgKOxxG/H9MhVtwSHDLls3XnqMcrcIHHuEyVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AgEsjcTGgunJSPxogmF+1QI7Bda+nKwKoMw8qsnVQss=;
 b=n2jXlHVlZcxJ4aS6Y2LQk3DhpJUTcVI26Za48qmsvoc00KPalDtKmwHiPL0/Je2ftVi62XrjzZKN9wVVsUAbliNpmJHGqSuvurr+t/Yw7GuuGFO5eVit0TLbGvkleKvHudE69Az1oWs9EkwcNtY5zPNnYqN4Zl+/pBQPoeBB1Z0I3LJot3UBuXFearFAyC3RxymFv5k0hnr1Vq9kU/TjfN2OzxN1S7usROegyl1ThycPJZe5ALmvo7nQb8yMMrR0w4ko7EA6W+md2YdmqN1FZN+9klawTWAol4lSSg/BYbl4hV6Ji6QScpUmF3+5hdUPxDh2wbHAFR37Z+R8DT2A/w==
Received: from PAXPR04MB8459.eurprd04.prod.outlook.com (2603:10a6:102:1da::15)
 by DU2PR04MB8726.eurprd04.prod.outlook.com (2603:10a6:10:2dd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.31; Thu, 22 May
 2025 06:39:11 +0000
Received: from PAXPR04MB8459.eurprd04.prod.outlook.com
 ([fe80::165a:30a2:5835:9630]) by PAXPR04MB8459.eurprd04.prod.outlook.com
 ([fe80::165a:30a2:5835:9630%4]) with mapi id 15.20.8722.031; Thu, 22 May 2025
 06:39:11 +0000
From: Peng Fan <peng.fan@nxp.com>
To: Arnd Bergmann <arnd@kernel.org>, Kent Overstreet
	<kent.overstreet@linux.dev>
CC: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>,
	"moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE"
	<linux-arm-kernel@lists.infradead.org>
Subject: error: the frame size of 1552 bytes is larger than 1280 bytes when
 building bcachefs
Thread-Topic: error: the frame size of 1552 bytes is larger than 1280 bytes
 when building bcachefs
Thread-Index: AdvK5BugLAt56HnRQGioX/TkvS3ASA==
Date: Thu, 22 May 2025 06:39:11 +0000
Message-ID:
 <PAXPR04MB845954FBBF2AD810B17536138899A@PAXPR04MB8459.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB8459:EE_|DU2PR04MB8726:EE_
x-ms-office365-filtering-correlation-id: d05e925d-918a-4397-cd9a-08dd98fb5c7c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?zTeZ1lUuoF/H7KgsZms7nM1STedJqD4bXuNzTLomyrU3VMF/cOAgcxxm4vu7?=
 =?us-ascii?Q?MEDsaxqzjnUJ9PKS1EeW/AoDWek+MeESrZtbIRiRuLbSLEbFCn3lyO37Nhk4?=
 =?us-ascii?Q?agp6Yfg7j2DH+F9B5jxP7TT7DceKjx/oyjpQcRLeDUMGtYRaIwMLCMTH+f12?=
 =?us-ascii?Q?dGR0Mf5dhfOh1HwEwHmaAUHXLYe+SwX2yZdkiRJsFiZAg0RDRAYdxX8ilTay?=
 =?us-ascii?Q?+59nHHltPSu77vIWuywroHo70toyoUiGUYo3cUgnt3pP+aBPk2Lh6gRPdLff?=
 =?us-ascii?Q?OghNVt+eVxYCXUVeiY1u6rrb2Ifg+4cVXheleCEaZ8uKMsvmiaT13qZASPq/?=
 =?us-ascii?Q?gjmX5OUy7f25PXek2imSQhzHN/TerG1PAdmu0IPi2UVnv6h1kRiLoNOzJfvu?=
 =?us-ascii?Q?rJLoTqxZb3DSmCVUsTy89KrKTp++0jGCkGhYpMNjCNM/ef6PZT4TS2iY05Qn?=
 =?us-ascii?Q?jpUq88SJuKDeaqvO+ZWp3FOmwkBS+Jc1KN5ow9OhfTk+wIKdHHfl2hRSs6kZ?=
 =?us-ascii?Q?ADV+wMUwEsxPbXCqnSuje9JHqKqdyAR/0/EUpPkGqrGa0Hl/LBfXGCKQOg9g?=
 =?us-ascii?Q?uPPXYvjzJwwVsZQb0vKUvL0tEt3nsCGNrTsDWcDa/HQOewDZou5KMktadfqg?=
 =?us-ascii?Q?+fKYZS8mxLjhqeswJYo0GTGjB1aKqgXAeLrvQ+FYkAPGhLOnuaXb5j1pqUdg?=
 =?us-ascii?Q?8u+n8hBiFCyopwTNn3cdv6O7x4gbRX0ZYOma6lO7OngT/SdQeOgeLJLLl56Q?=
 =?us-ascii?Q?Eb70n2Kc2k/ae4UGoEzNWo0+pOBRFaoe2M8fovJvkg/QVL5y2e5WKGI9iNMF?=
 =?us-ascii?Q?8W5H9/LBmx0RrR0SZyIFpL/HtmL4T8eQiOzKvWuuRFH3C/AzQGxLqZuzFYf3?=
 =?us-ascii?Q?Vm18ICvampg8VfgXADAl63CJhs9jKLfDF8mXIsp/g10f9AfOm7nZwIKaSSoM?=
 =?us-ascii?Q?3VK1b9Z2Zq3btTmgd+QVfpiOeLAGUUXl2tSpYspGwokHqWJoxCiS6CwEknuv?=
 =?us-ascii?Q?chl9oxujOVhkTOB03dY3HKELhh+7hgE02aflV7FcVSTPLlv1vgGXhMy35bVo?=
 =?us-ascii?Q?P1Slm1WawYeJPsCI95GpJ7hwvpNbiHWPI9DxmkyZRa19KDpbe30Hbgq6w8Vb?=
 =?us-ascii?Q?uEY6c/HKSP8wRQPRpmuHHatkFZr1tyLU/vm1CumacI0TXtxsXnyl5LGRxAhy?=
 =?us-ascii?Q?yoa7+0Mergv9GkTGqQ9CaWQipM4eIZvIJuaQFPdpiolCbwzPxHGnnmlgwbxv?=
 =?us-ascii?Q?V6fEhZsRNsrwq79Fc9y/yI0B4KT52X3zKM0Poai+SZFvm/TjlXYZOCgn1x3V?=
 =?us-ascii?Q?WZ/js6LVcdmtVlXW1SSjSE+r85lnWJmWHlHRpsRfVJrxYBSc/B4S0LMnzSDa?=
 =?us-ascii?Q?V2CEndHjXvgi46M0vpSqvVKqLM9DMWIaX3Jf6SgDWW4aNe3jUUVRka8g3uZ+?=
 =?us-ascii?Q?/nWXyVx2pB0yKY45kTPRSu9KRxhropejv+A88ttsUgacG9VEGB+vMw=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB8459.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?F1+0mulozecSyCCOMS8QBEUu61XidAgCnho1hJnCxPITn/sb/u1Ku+AMquRv?=
 =?us-ascii?Q?w9U1cOkOKMeIXIXcyMFSP6SJmh6XuOsFIJ/llzEZzJbe5VUGOayPT8qz8xka?=
 =?us-ascii?Q?aTAsFPgGheZZNI44sb6ttP6wobkbpsY2NZ7ksz0FutL74JhK5uVA0Oqdty1o?=
 =?us-ascii?Q?MdnKGRL9kBglXbN0T1LlXhj7WXYCDHYq4+EIVlS9JElovohEDSIujoCiiCrZ?=
 =?us-ascii?Q?mlLMKZcKE97VgJoH5rI3KfK1KpFRjjJ+TQYbmJ8nLkV+E/9dhvfzJsFfKON5?=
 =?us-ascii?Q?BMuPykYdQbGW2jDLCncRChk0rm/xupkNRLaNbjEPqZhZ5rJGeSKavAyqPBIL?=
 =?us-ascii?Q?sMCHfqLKr6vzTqDn8VYxiCwq+kJRQzyLLKuFYKl8c0donvYp1ZO+OZ3o4ed2?=
 =?us-ascii?Q?gGKR14Mtag/YImI+f6ff4mBqHnVstpAKlgIPvxsm4PlqX9Ql7a1J8OAtvzW0?=
 =?us-ascii?Q?jqgf6S3YxSPfb+BY30wxEbLQH/6vYbsdOEC0nR/zkJdQBbLESN8ZNhYOffAK?=
 =?us-ascii?Q?K/oNJLjhTOBf6aVtyOrR7zsdMDw0DsIsl5y0GgkklVeJBz7jAp0auWzunpab?=
 =?us-ascii?Q?hBYPpmVQeV1ZthZcr8IPceuEs1Sth5HEIb4egzPbY3nQINwaLqgREh4OFHiT?=
 =?us-ascii?Q?bjTbK+oVZuaaIlwEJbHcMd9VbGVFJO7/D9PiOJtCpRViMu50gvnXD95GNrz/?=
 =?us-ascii?Q?HpBJ+IqtuhdBZdxoxRame2Ucx3ygW7WZkIhTF9sDpRE0ztcbWmkRmF8BCQw4?=
 =?us-ascii?Q?q0QMSX684TASlq5Hf2dfQDzAehTnO03ZVHw6QCtoBdLqVf8kfnSlxlVX2ijg?=
 =?us-ascii?Q?Kc5emRYLUGyyFpGQH9NUSyITl/ocyeZEMRyFmsZTA4V7hrZNg8QNfn2AO1bG?=
 =?us-ascii?Q?bGxPI7xgkK6KXsY9uhcdCWYsk+tiYbwH/FY12/vhZ1bz32kzkmrXGdyb4q1j?=
 =?us-ascii?Q?uf4UEsiOpmf6wiXDCt/78VgTGBFd5Kj6NvJhAY5ljmupPAjEsQ1w/X6ptTHZ?=
 =?us-ascii?Q?cIsDOKf1tVw1VkdTmea0oDaRiffrQtZ+zlK/Kjwsip9fH4diy9JIpxuLmRVg?=
 =?us-ascii?Q?Jrb3he18YSRP9VKzYhlXBwz57kJEy67rUMdrJLet8bmU1Qxrgid9sxDLBDSU?=
 =?us-ascii?Q?fI3u1i//cGX02wptmArfV+iNFAfwruk9St4oqlVy7Fm/PmPMMCPZdSNzNtUK?=
 =?us-ascii?Q?9J35G3WNG9TdF6J8QRpQ0pT8Y3ZHMoT/4ATbY+oGR+dlpvkkxZTqkvDL72n2?=
 =?us-ascii?Q?rmHPYpEOEWddmy4O5ztBljHrgwgvctTgEXmWKo4XpaEkKlsVfUa9j5QtW0x4?=
 =?us-ascii?Q?Z3fcajja3oTWrmGSmdlfjtA4s4dsfD9WXb4b96ph1eHBqcLhpblvfhavhvBJ?=
 =?us-ascii?Q?IzW/q68t71NFQfEQq6aBucCOFKUcSVhdNUdn0JKB2i4LqCsVrRazlUWU6WmT?=
 =?us-ascii?Q?Ry3HD2JSDuxiYi/Xlh3SdwsiP8WrT4HIkvr+KWCTvHOF022s+QlT455Tjgmn?=
 =?us-ascii?Q?Gb42pDIm/RNVeoCms883rg+lq2HwXixgjlULsbap+b5QwOs1Fc7pVfthbGMl?=
 =?us-ascii?Q?LC6bcx4+Sy3Ls5qV+zA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB8459.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d05e925d-918a-4397-cd9a-08dd98fb5c7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2025 06:39:11.1843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ImdhCV48SOses0tEPmPvtwbBr7xST/C+AcLdknHDeO108+oY8lrvegondxYaXs4gHQRntDTRsE+tGrwjuDe4Kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8726

Hi Kent, Arnd

There is below build error with "make ARCH=3Darm randconfig; make"

fs/bcachefs/data_update.c: In function '__bch2_data_update_index_update':
fs/bcachefs/data_update.c:439:1: error: the frame size of 1552 bytes is lar=
ger than 1280 bytes [-Werror=3Dframe-larger-than=3D]
  439 | }
      | ^
cc1: all warnings being treated as errors
make[4]: *** [scripts/Makefile.build:203: fs/bcachefs/data_update.o] Error =
1
make[3]: *** [scripts/Makefile.build:461: fs/bcachefs] Error 2
make[2]: *** [scripts/Makefile.build:461: fs] Error 2
make[1]: *** [/home/nxa18884/linux/linux-next/Makefile:2006: .] Error 2
make: *** [Makefile:248: __sub-make] Error 2


Toolchain:
arm-poky-linux-gnueabi-gcc -v
Using built-in specs.
COLLECT_GCC=3Darm-poky-linux-gnueabi-gcc
COLLECT_LTO_WRAPPER=3D/opt/fsl-imx-internal-xwayland/6.6-scarthgap/sysroots=
/x86_64-pokysdk-linux/usr/libexec/arm-poky-linux-gnueabi/gcc/arm-poky-linux=
-gnueabi/13.3.0/lto-wrapper
Target: arm-poky-linux-gnueabi
Configured with: ../../../../../../work-shared/gcc-13.3.0-r0/gcc-13.3.0/con=
figure --build=3Dx86_64-linux --host=3Dx86_64-pokysdk-linux --target=3Darm-=
poky-linux-gnueabi --prefix=3D/usr/local/oe-sdk-hardcoded-buildpath/sysroot=
s/x86_64-pokysdk-linux/usr --exec_prefix=3D/usr/local/oe-sdk-hardcoded-buil=
dpath/sysroots/x86_64-pokysdk-linux/usr --bindir=3D/usr/local/oe-sdk-hardco=
ded-buildpath/sysroots/x86_64-pokysdk-linux/usr/bin/arm-poky-linux-gnueabi =
--sbindir=3D/usr/local/oe-sdk-hardcoded-buildpath/sysroots/x86_64-pokysdk-l=
inux/usr/bin/arm-poky-linux-gnueabi --libexecdir=3D/usr/local/oe-sdk-hardco=
ded-buildpath/sysroots/x86_64-pokysdk-linux/usr/libexec/arm-poky-linux-gnue=
abi --datadir=3D/usr/local/oe-sdk-hardcoded-buildpath/sysroots/x86_64-pokys=
dk-linux/usr/share --sysconfdir=3D/usr/local/oe-sdk-hardcoded-buildpath/sys=
roots/x86_64-pokysdk-linux/etc --sharedstatedir=3D/usr/local/oe-sdk-hardcod=
ed-buildpath/sysroots/x86_64-pokysdk-linux/com --localstatedir=3D/usr/local=
/oe-sdk-hardcoded-buildpath/sysroots/x86_64-pokysdk-linux/var --libdir=3D/u=
sr/local/oe-sdk-hardcoded-buildpath/sysroots/x86_64-pokysdk-linux/usr/lib/a=
rm-poky-linux-gnueabi --includedir=3D/usr/local/oe-sdk-hardcoded-buildpath/=
sysroots/x86_64-pokysdk-linux/usr/include --oldincludedir=3D/usr/local/oe-s=
dk-hardcoded-buildpath/sysroots/x86_64-pokysdk-linux/usr/include --infodir=
=3D/usr/local/oe-sdk-hardcoded-buildpath/sysroots/x86_64-pokysdk-linux/usr/=
share/info --mandir=3D/usr/local/oe-sdk-hardcoded-buildpath/sysroots/x86_64=
-pokysdk-linux/usr/share/man --disable-silent-rules --disable-dependency-tr=
acking --with-libtool-sysroot=3D/home/bamboo/bamboo-agent-home/xml-data/bui=
ld-dir/IMXYOCTO-SDK-MX6QPDL/112/build/tmp/work/x86_64-nativesdk-pokysdk-lin=
ux/gcc-cross-canadian-arm/13.3.0/recipe-sysroot --with-gnu-ld --enable-shar=
ed --enable-languages=3Dc,c++ --enable-threads=3Dposix --enable-multilib --=
enable-default-pie --enable-c99 --enable-long-long --enable-symvers=3Dgnu -=
-enable-libstdcxx-pch --program-prefix=3Darm-poky-linux-gnueabi- --without-=
local-prefix --disable-install-libiberty --disable-libssp --enable-libitm -=
-enable-lto --disable-bootstrap --with-system-zlib --with-linker-hash-style=
=3Dgnu --enable-linker-build-id --with-ppl=3Dno --with-cloog=3Dno --enable-=
checking=3Drelease --enable-cheaders=3Dc_global --without-isl --with-gxx-in=
clude-dir=3D/not/exist/usr/include/c++/13.3.0 --with-build-time-tools=3D/ho=
me/bamboo/bamboo-agent-home/xml-data/build-dir/IMXYOCTO-SDK-MX6QPDL/112/bui=
ld/tmp/work/x86_64-nativesdk-pokysdk-linux/gcc-cross-canadian-arm/13.3.0/re=
cipe-sysroot-native/usr/arm-poky-linux-gnueabi/bin --with-sysroot=3D/not/ex=
ist --with-build-sysroot=3D/home/bamboo/bamboo-agent-home/xml-data/build-di=
r/IMXYOCTO-SDK-MX6QPDL/112/build/tmp/work/x86_64-nativesdk-pokysdk-linux/gc=
c-cross-canadian-arm/13.3.0/recipe-sysroot --with-plugin-ld=3Dld --enable-p=
oison-system-directories --disable-static --enable-nls --with-glibc-version=
=3D2.28 --enable-initfini-array
Thread model: posix
Supported LTO compression algorithms: zlib zstd
gcc version 13.3.0 (GCC)

Regards,
Peng.

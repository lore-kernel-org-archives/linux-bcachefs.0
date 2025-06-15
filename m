Received: from SJ2PR03CU002.outbound.protection.outlook.com (mail-westusazon11023096.outbound.protection.outlook.com [52.101.44.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C1A8462
	for <linux-bcachefs@vger.kernel.org>; Sun, 15 Jun 2025 03:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.44.96
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749956571; cv=fail; b=VafPbnZnZ+KHsK2rMQ1ucIzuiCglhQSlJWtO/+giRqGWXxi7zLb9BJoyIhuw07x0/R7xM54ux+Yq/Vrm02RdchHkEBsjQb1T2lbfjFz3lNr5iODpjbzcBoBrOnYBaLEc9eumfIeIMn2a2eVYlmTL9ZaszFwwFeHVY0gYBFRlbaM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749956571; c=relaxed/simple;
	bh=b/MEKTnZh454Kl7q9yul5iUUTRY4teLMg5u0V6SrzS8=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=pn4k+fE/Ngj56X/fm1q84hX/z1EwlJ0q7Cg2rw338n8xLNgRxd+WIxzduKlhUNnK1WKODQ/+7Q/SzJig15oTKFIiyffkpCYPi++fUDMatn8QlMNvI/YXYNCu+PaC6Y5V5t6bVXYO4FiQ4kDgPLhNMLb3163Eyf8UvNRs03H8CCk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aaronfriel.com; spf=pass smtp.mailfrom=aaronfriel.com; dkim=pass (1024-bit key) header.d=FRIELTEK.onmicrosoft.com header.i=@FRIELTEK.onmicrosoft.com header.b=mD09FmzE; arc=fail smtp.client-ip=52.101.44.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aaronfriel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aaronfriel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=FRIELTEK.onmicrosoft.com header.i=@FRIELTEK.onmicrosoft.com header.b="mD09FmzE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=va/hFeK54JbpwcB8OO8tE+wgZpsHL/Tgd79/TGgSnKSkHEV5AYFI4E25LaOEHtBbGqF+fQoOMrqLmVPjiO09lHazlwpibWGOjXpYst0K6wTQCH6h0edCPSr9puEoEBJUMKpgdE6CTZpPTGULJz+sbJZSnyIIuM7BLeggXn6PWNGzi880mrEVqFwy+C0vj3jNXDxm7fqGXz9oKSNnGgQXsJieAc9urvW4/jCY+uKFYYRYSTkdsW9dweUNU4TBBWFiL8/D7bMbhj2y+4DkjqURBxdv811HZseK/yRdmn968AzOoJ9KrnX9GXLU7o3Vq/ycQ3LAkhX9L4uHYfyaXa93vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b/MEKTnZh454Kl7q9yul5iUUTRY4teLMg5u0V6SrzS8=;
 b=qwthBQKpOU063Hv7BcR2eqPgfFYy1+f7UCjN4qfD3mKXCL5XmSUntjBTKoPDMzzA9jvdyVOU+QiMl23Z6QN+J3qvEVv/fHI4W1WF8v4Uokfgy+9YWnPJu9/UnloRPbTjLJG/NjYY3xXzbb8yGDBxoWN/SHAVByzjI0lOAv1gdb019YZLokLo4oviYvwGFNBOGvZ6cmzLSPLlWJGijgsPZtgdiDl+h4QxypBSaySTxPPiYCT+bxe8Elev7M+Ubwi+kZLY9RsFfs0HEbqFsZTqOUZCZkxliCSLUe7KG7OU1CWVP/7fFdIrDbD1Fly9mo0YnyU1ce7SRWsCkCRzgnMt/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aaronfriel.com; dmarc=pass action=none
 header.from=aaronfriel.com; dkim=pass header.d=aaronfriel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=FRIELTEK.onmicrosoft.com; s=selector2-FRIELTEK-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b/MEKTnZh454Kl7q9yul5iUUTRY4teLMg5u0V6SrzS8=;
 b=mD09FmzERluSIYpROp6OiyiiRzY/7uUeWK/XJRwPodgbq6r++EtgwWop8KTSWNBwgQJANe8wugGtH/btXZNlT+j/vtbRi46frUpFPoSRAJLA6knptRuuxQqZmA2jmEpVrFyN0h4cHywzbAH0ZWqhi05/eFr/hVh4xmrORLJ18kM=
Received: from MW4PR05MB9993.namprd05.prod.outlook.com (2603:10b6:303:1ef::21)
 by PH0PR05MB9727.namprd05.prod.outlook.com (2603:10b6:510:26d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.29; Sun, 15 Jun
 2025 03:02:48 +0000
Received: from MW4PR05MB9993.namprd05.prod.outlook.com
 ([fe80::da:f56d:ad76:326e]) by MW4PR05MB9993.namprd05.prod.outlook.com
 ([fe80::da:f56d:ad76:326e%4]) with mapi id 15.20.8835.027; Sun, 15 Jun 2025
 03:02:47 +0000
From: Aaron Friel <mayreply@aaronfriel.com>
To: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Issues setting durability on new devices in bcachefs
Thread-Topic: Issues setting durability on new devices in bcachefs
Thread-Index: AQHb3aG7BcdLvKRiWEq49GHsrqA8xw==
Date: Sun, 15 Jun 2025 03:02:47 +0000
Message-ID:
 <MW4PR05MB99934C43FB32313C921D7765B571A@MW4PR05MB9993.namprd05.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=aaronfriel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR05MB9993:EE_|PH0PR05MB9727:EE_
x-ms-office365-filtering-correlation-id: 5c0d52a5-5c9a-48a2-7420-08ddabb91b6c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?PXUDmx6X5olD+Dmdu23d3bxZAxEn6U0xiGjyIvimRncddkml+S/TuI+FYj?=
 =?iso-8859-1?Q?AaqDjpa96319ZUQs8B1Qq+mPH2aP7dCfO59fbAohIIv+QLfH4hvzT0DOgq?=
 =?iso-8859-1?Q?0ccivZ1+oHzV3izkBM4ZTfCgV5q8H5Vj7Oti0eLCxxMPaHVVFdDLUQzmVB?=
 =?iso-8859-1?Q?6odLchyJcgyeIkXCBmLwoP+L0iSbG5MAIwbmkgkLL/VXM0DVbJPnoAv1wu?=
 =?iso-8859-1?Q?SzpRLeUyFOhRHp1rhWgnnA7WFHSeS9GcP3JxU5xGU4xS4OrAREC0dvf123?=
 =?iso-8859-1?Q?MggLJ+OGdWz76mR1d+llirajNzBPLu1y/WqQZ2QVmcmF4uU/RPjrDAG6Qd?=
 =?iso-8859-1?Q?KoFCzbeAr52yE4ryi7ksBek7omZ8YRFVS/LRPTEmviTORzRXOUqmOZ0hCO?=
 =?iso-8859-1?Q?2mr3BYQ2FtLSn031tWy8Ipx1Kz0rkuUWUcRK4ubJJxeWLEY4q9LCvnbc8D?=
 =?iso-8859-1?Q?3knYkzeowpeoMSMK9VlnH86jAyGo/l6Fvm2eeS0MtIUL/CcMjEGmReZE0l?=
 =?iso-8859-1?Q?YOFti6M+lFrfvcEEjrvu7Hj6mudsDGIA+UVTRkIWeAbbTCAxQKF3mCJ0By?=
 =?iso-8859-1?Q?ofAjqPJC4rKdZNMzppCiO9nMLh6VM+wePY0/bfazrrlSV/9ewSCRct02ub?=
 =?iso-8859-1?Q?f0xvP4jsqO+aWH4o2k53ojnAjo7OMel+qBFJd1khnmKHn8xBvEc6uqWkMh?=
 =?iso-8859-1?Q?EOE8UCgNPpkx4sh998PL1k1riuWQKFeYAemAoyPlNPzq1PH7n1ZWikgpcC?=
 =?iso-8859-1?Q?0t184WeUL2+5JijKDn9MSj77Q5lSYQPOnUw/GpXgJYvdiq/YbtuvgyKGaG?=
 =?iso-8859-1?Q?rbi9bJfoT9P3R/feETIFdhUeG37DIgm4cQV/DAzbPJgndBKz3HpYzbOjvp?=
 =?iso-8859-1?Q?4j9H/DSJiPQ2mgtdjrdB1PgYjXsbUZ00hrih0XoenQhvVbvAlIkXcZ1Cds?=
 =?iso-8859-1?Q?Bh7Dk2ZatrqmOojdALw2uysXtBQg+a7g27Md0A+SDMniAyKxcsEw8TH9qN?=
 =?iso-8859-1?Q?47Km9hmf50Kj4G5gV2qyFFMbr74GsUeVJ7/pFWxRN/j3tzr/sw+abeA7vW?=
 =?iso-8859-1?Q?3jFBcjDaFTPbgq57EmvZ3gPHxl7sWk22qSIEUUUTVfFcUaZgNz1pU2LLY3?=
 =?iso-8859-1?Q?DmQKAbJRKvR4Vkc+SLtZtV/mX00Uc/EkxuHrSz+43WOZ8nlXkJTnCDta6B?=
 =?iso-8859-1?Q?lExrEmWfLFJQe9MtE8it5ByFIVFnUMLthVN8W22QaxRtuWgBoz0zA3fSmI?=
 =?iso-8859-1?Q?Oy8b54xUri1AuB5slNOxSOudFrHQTbiXfRi6DrL9gf+DorcPEY5gn/qCg3?=
 =?iso-8859-1?Q?o7gho4o6gZxDKnPOuwHedibLBynOmSYoM7zLqNItwzd0JwtGQY8orSE0ql?=
 =?iso-8859-1?Q?wYulCON1RKfN1Ms9zS0xCN4sXWVhD9Ydy6zgxuScdbLnBK8VZzGjuorbNn?=
 =?iso-8859-1?Q?O/KvCK1OZ1AmYeaZk8kK7iTb4JBsiNrMYwIc54ujjyoP1yI//8h5ZaAClz?=
 =?iso-8859-1?Q?vx9rqKyxGgLUzFcgecwOGK4w8ApRlTGOnBbkdzRmrTgRIMUFH4gKsgIm+h?=
 =?iso-8859-1?Q?RN6/q9M=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR05MB9993.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?BrLrWztjA+swhAA25EVe1AH8LNuM3R9P0W2d0KPHEMhkl5HJea10PXx0XP?=
 =?iso-8859-1?Q?92M9UZajMLjH3QvscrxE9YOZu8ijXEer/iKh4r0fDJMfZX1dhTxGCYAZTz?=
 =?iso-8859-1?Q?EDFUkby+6RuzFOnVJ/E0ShK7JggUopnvjFy9sFvvTG2vP6dy45lYgGeyEX?=
 =?iso-8859-1?Q?yW8DpmoZHakzEAVzWiS46qPY9P8daUWbGOOfoSgNA0QA1srWgh9aICjtrH?=
 =?iso-8859-1?Q?1aygECK9IkN762aGKAHDXi2Mu0qG0DJYNtNvN9KC89LS+94MfnwhQ8bEOL?=
 =?iso-8859-1?Q?DSWhZATthszLpPLrtl32itMD2e09vLnAEBotOzaJhUfx13FY/Mvd8Wx6IW?=
 =?iso-8859-1?Q?CPiHypSRPQmS5AwzzTrG0s/itgWXqCQay56lT4C82lf67h9WtV7poSygVw?=
 =?iso-8859-1?Q?C+VwfrylETPBmDFniUSDSHeS37glvMZpUxqaeNtRuWM3voslyUOf6nJ1P2?=
 =?iso-8859-1?Q?Hir7gp00WY71CIk0jqaN3yzzwdXeqC8GJJFo1cy3j/yO66xywFVKdjvYYC?=
 =?iso-8859-1?Q?MdCypMCnwLrvysW5Tp361XGP8jHOdG8JqeJqHZoIxg6dhUZ0oXUlC4c0k+?=
 =?iso-8859-1?Q?JaQ9qVJRBEQ7TbROSNHPbBVrKA7nQqqMKQePE1PEWBOHngih8QIyL3NVOu?=
 =?iso-8859-1?Q?Dpea09qIlR3b33eO2O/im0j6KeCYn9M/giN5duvgPdviU1H9aFmiMReRuy?=
 =?iso-8859-1?Q?VFHH3xZ4WMDSrAWQc1zfAJ5qgQ0vmABiax0fcbdAun/RG/BlX72c5dfGkv?=
 =?iso-8859-1?Q?d7dSLjf1FkCZeFOh8mOIv7DB/jsGaQtFJJK2k43Z963b5gUiqEVFIwScAK?=
 =?iso-8859-1?Q?9u3tt2JNtYck5gCtAnzucQrOzMKlEUfbfkN9vNXHBOeBfBQkOV1jFyc7ll?=
 =?iso-8859-1?Q?+8Z8fHAHtJuWKxEXse0//aZ/pw1+l5ah8pT5jtKRSI83XaiL6QM4njrkNA?=
 =?iso-8859-1?Q?98jN+QvmrPVhciW/nyO4BY+lWYUyMQkSnhqUAe/XKeqNOJmGMLSrgdErCd?=
 =?iso-8859-1?Q?dnvJinPnz2ZYGFjIY660SWJhPBtW1aBoniDifYUyuLahxjOkZOliIOEt2e?=
 =?iso-8859-1?Q?aiyEoiOQOmA2IBxxH/ycjFyasU+PTBIAAYKadosZ0XCHi2763F2f1Gf5C1?=
 =?iso-8859-1?Q?HH/5D0y+zqJktz6fqrMMgmw6iVKp/f8j9JIQiQhAbEIvz1Sk3epKhjAGg4?=
 =?iso-8859-1?Q?t5YcOLNI6hjSsBhUmxXSOjMJpsCQwunpsO4LRRSrNh/gtHDFe/BrTqwuB2?=
 =?iso-8859-1?Q?Vnn0/nkjl3RQS4uPTrUOse4tJnbFJHT70Mk9C/G/sRTpWNSLFOw2biYqgz?=
 =?iso-8859-1?Q?pglEVh9YiLPKlILY78+bbu4UeNJLMSNV2ZsZJnFaOyeWizXBSeB7jnx7B1?=
 =?iso-8859-1?Q?ysk+kXwA4ORz3fglB8SVq6J9MJvNkYRxv5WMyYZty7LPQO8o3lCMjBsJMs?=
 =?iso-8859-1?Q?/iWr/QH0cppufkgJUe3o3fggCFaWBNvldLmq01fd5IZC3oj5xsuykgdaWo?=
 =?iso-8859-1?Q?QBp315kEytblZby+a6A8DXSgae8T9pdXo1/moKaSvkCgf96ypb5C8ZsgKv?=
 =?iso-8859-1?Q?PbvGugyroahWdN5KCgwcaXr5WOpPJwkDwFjzR6CCCgnI+L6Id89aSMA0eL?=
 =?iso-8859-1?Q?5BWeqO8ElPj3PXBmJv00BHL/G9Ty3EnG74?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c0d52a5-5c9a-48a2-7420-08ddabb91b6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2025 03:02:47.3611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd1ff30b-4659-4018-98d4-c7ec5f672515
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tebYIsE97jjeJwx5FsahoHAiZiK+DLVO8Xm0t+N8XpWCsfNTYZF8EAob4UGEFJShaeK9i0AaNNtncvXZWgYdAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR05MB9727

Hey Kent,=0A=
=0A=
I reported an issue on Reddit with bcachefs, attempting to set durability >=
 1 on an additional device in the pool. Not having the best luck!=0A=
=0A=
https://www.reddit.com/r/bcachefs/comments/1lbpxvs/unable_to_set_durability=
_on_new_devices_segfault/=0A=
=0A=
It looks like Fedora 42 is still on 6.14, so maybe this is fixed with a ker=
nel bump or a new version of the tools? I hope so - would really like to ma=
ke use of it for a tiered array.=0A=
=0A=
Cheers,=0A=
=0A=
Aaron Friel=

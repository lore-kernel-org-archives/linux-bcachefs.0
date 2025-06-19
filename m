Received: from mail-edgeMUC220.fraunhofer.de (mail-edgemuc220.fraunhofer.de [192.102.154.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D56B21E0AF
	for <linux-bcachefs@vger.kernel.org>; Thu, 19 Jun 2025 14:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.102.154.220
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750344875; cv=fail; b=U+yAPp6+hj5QMvP86QcipJAoTNha1MYQxnPJNTwZHeDCmU5dDw5STwXBVg4Ql+1TDsmsLCwIYdq9iZ/cVByWcEsKs6/khiiECDcAJtwTosjAthOz+cfjgPTYrEbVIAHeAGzR+Y4d2DOF3QzAk8Z5unFlPbK8Ii0WSDe1n7lfXvo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750344875; c=relaxed/simple;
	bh=CZfvJRmKoOKOtnF6yHYrD5tWcud0JZYaDfiw5Fl0C9A=;
	h=Message-ID:Date:To:CC:From:Subject:Content-Type:MIME-Version; b=BNzBOyVTAg9BZRqepiovxgpLHfB2WVBivYKvTmkqqk+oU+5sfdZwUvM0qu+6VIvfioSkC+VWDzmh9ra+0bQdSc6gsRleIYfAcIvhv23Jy8T8vH0H7gvieIDRYZENIVW/PXvhvaRqkcF3h45brFP5cGMm8A+tKPa6IRCMnRtXDNo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aisec.fraunhofer.de; spf=pass smtp.mailfrom=aisec.fraunhofer.de; dkim=pass (2048-bit key) header.d=aisec.fraunhofer.de header.i=@aisec.fraunhofer.de header.b=mj8YpT9+; dkim=pass (1024-bit key) header.d=fraunhofer.onmicrosoft.com header.i=@fraunhofer.onmicrosoft.com header.b=U1LzXB5P; arc=fail smtp.client-ip=192.102.154.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aisec.fraunhofer.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aisec.fraunhofer.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aisec.fraunhofer.de header.i=@aisec.fraunhofer.de header.b="mj8YpT9+";
	dkim=pass (1024-bit key) header.d=fraunhofer.onmicrosoft.com header.i=@fraunhofer.onmicrosoft.com header.b="U1LzXB5P"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=aisec.fraunhofer.de; i=@aisec.fraunhofer.de;
  q=dns/txt; s=emailbd1; t=1750344867; x=1781880867;
  h=message-id:date:to:cc:from:subject:
   content-transfer-encoding:mime-version;
  bh=CZfvJRmKoOKOtnF6yHYrD5tWcud0JZYaDfiw5Fl0C9A=;
  b=mj8YpT9+agCtr8P1NJjX8zPhupL5L4rnZiUVILoJDMS6woKJEjkQxN+9
   VTk4+wb705nPGzJF+LiqMekmyJp7XeNZJDYp4Nr1NGCpuIzPEAoXMdmLd
   jDQhEmLsZjLB6HyO/z5N1bQlCKAsyxT+OlO2Y5oew/ZytlGTSqGrgVfWu
   SXWNsj+UdasTIS7k/Z49GJAY4J82hyfbdsNKFEVSPWWvqj2CbLPmrdg1v
   8lHgBDZYNIJFfLtIArFkzfnfeTouLaYUBkoOLr7zJBd5+EyQ7p5b9WBfv
   7tv4O34X1UAU0r64Nwba0uRbIwTZKOr88GQyWvMk1Vk2u++kiIKS/o4zL
   Q==;
X-CSE-ConnectionGUID: xwyGY2CgRO2q3k+U0xFqLA==
X-CSE-MsgGUID: 3OO7Rv9GSFGU16Rwzb4YHA==
Authentication-Results: mail-edgeMUC220.fraunhofer.de; dkim=pass (signature verified) header.i=@fraunhofer.onmicrosoft.com
X-IPAS-Result: =?us-ascii?q?A2GWJACVI1Ro/ycF4gpaGwEBAQE8AQEBAwMBAQECAQEBB?=
 =?us-ascii?q?QEBARWBUwKCQkABgiSEVa41KoErgSUDVw8BAQEBAQEBAQEIARQTKgQBAQMEh?=
 =?us-ascii?q?QCLayc2Bw4BAQEBAwEBAQEBAgUBAQEBAQEBAQEBAQsBAQYBAgEBAQQJAoEdh?=
 =?us-ascii?q?TVGDYQHgSYBAQEBAQEBAQEBAQEdAjV/HQEBNwE0AiYCMysOBwEBgn6CJAQSA?=
 =?us-ascii?q?zKuUYEygQGCDAEBBoJp2EAYgSeBIAkJAYERLgGDfIQ6GgFyjECBPAsDgkUBh?=
 =?us-ascii?q?Qc+OIMOgmmCKEFVgnGCYYRQjmCBShwDWSwBVRMXCwcFgWMDgQ9uMh2BJ4cxh?=
 =?us-ascii?q?EUrT4UgTFqDXiRwDwaBLEACAQttPTcJCxtDkmCDKIENWyAxpHSBNaF2B4I4g?=
 =?us-ascii?q?WYFlHeMXAYPBC+XWZMImQSjYYUuAgQCBAUCEAiBbwKCDTM+gzZSGQ+SIbdZd?=
 =?us-ascii?q?jwCBwsBAQMJgjmNU4F/AQE?=
IronPort-PHdr: A9a23:pwjs3xdsIlJxZ9SByumc+JZElGM+4d/LVj580XJao6wbK/fr9sH4J
 0Wa/vVk1gKXDs3QvuhJj+PGvqynQ2EE6IaMvCNnEtRAAhEfgNgQnwsuDdTDDkv+LfXwaDc9E
 tgEX1hgrDmgZFNYHMv1e1rI+Di89zcPHBX4OwdvY+PzH4/ZlcOs0O6uvpbUZlYt5nK9NJ1oK
 xDkgQzNu5stnIFgJ60tmD7EuWBBdOkT5E86DlWVgxv6+oKM7YZuoQFxnt9kycNaSqT9efYIC
 JljSRk2OGA84sLm8CLOSweC/FIweWUbmRkbZmqN5hGvdaX/rAnAs8l6/wq9IcvYE6EUaC6Os
 rtUQwLk0AU1BjcV/mDI1+J01IkKiUfywn43ydvpOaWHBNAjRpjlPss/YGhjGeFqdS5fBaCYb
 NMWJrcGMb1SvrLT/VIsvEGDIgiWHODqyCNutkL83vMq2dkLD0bA3lM/FPsCl1/opdfta445A
 cet4orBl2r7ZPdu/xPyua3sTRx7uva+DfFJe+7S0wo2CCbKt3KcudPIJDPN58FVtG7Ywrpbc
 Ma+um54jCpJ8zy9hdYgjafLpIE56hOc/BtjzJRrAduWY1ZwYtnxQ9NA8iCAMI1uRdk+Bntlo
 zs+1ugesIWgL0Diqbwizh/bLvGLfIWt3zm5Dr7XLy1xmXRlf7yynVC+/Bvoxu79U5ys2U1R5
 mpek9bKv2wQzRGb9MWdS/V880vgkTaC3gze8KdFdGg6j6PGLZ4mzLMq0J0VtEXIBCjtn0vqy
 qSRcy0Z
X-Talos-CUID: 9a23:e8PUcmBXBDj6ifz6Ezl45WElQOsqSFqH1SzTYHLgGUhwbJTAHA==
X-Talos-MUID: 9a23:b1jw4gpa9vPL2BAvaksez2pFE5hS/fWBM24irMxYgdaWP3BBGx7I2Q==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.16,248,1744063200"; 
   d="scan'208";a="10670207"
Received: from mail-mtamuc217-intra.mx.fraunhofer.de (HELO mail-mtaMUC217.fraunhofer.de) ([10.226.5.39])
  by mail-edgeMUC220.fraunhofer.de with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 19 Jun 2025 16:53:15 +0200
X-CSE-ConnectionGUID: CRjinu/YS9u3/KdlGyaO7w==
X-CSE-MsgGUID: o98Tzs46QvCLoXxoug0KSw==
IronPort-SDR: 6854245b_idZPRi3/SIM6M6Qb/OZU2BQVEsGrKDhJfgfeHt0OnjVOS3j
 EiIXyb7qoSOdstf5RS3BVT9KKp8L3vYJwBcbicQ==
X-IPAS-Result: =?us-ascii?q?A0DdMQCVI1Ro/3+zYZlaHQEBPAEFBQECAQkBFQkcgS4Cg?=
 =?us-ascii?q?XBSBzkBB4EUgQmEVINNAQGFLIZVAYJbAZwygSuBJQNXDwEDAQEBAQEIARQ9B?=
 =?us-ascii?q?AEBhQeLaAInNgcOAQIBAQIBAQEBAwIDAQEBAQEBAQEBAQELAQEFAQEBAgEBB?=
 =?us-ascii?q?gWBDhOFew2GXRYRHQEBFCMBNAImAjMHJA4HAQEegmCCJAQSAzICAgKhYwGBQ?=
 =?us-ascii?q?AKLJYEygQGCDAEBBgQEgmHYQBiBJ4EgCQkBgREuAYN8hDoaAXKMQIE8CwOCR?=
 =?us-ascii?q?QGFB3aDDoJpgihBVYJxgmGEUI5ggUocA1ksAVUTFwsHBYFjA4EPbjIdgSeHM?=
 =?us-ascii?q?YRFK0+FIExag14kcA8GgSxAAgELbT03CQsbQ5JggyiBDVsgMaR0gTWhdgeCO?=
 =?us-ascii?q?IFmBZR3jFwGDwQvl1mTCJkEo2GFLgIEAgQFAhABAQaBbwIzgVkzPoM2TwMZD?=
 =?us-ascii?q?5Iht1lDMzwCBwsBAQMJgjmNU4F9AQE?=
IronPort-PHdr: A9a23:rUE//xJk/AazZu9mbNmcuDZnWUAX0o4cQyYLv8N0w7sbaL+quo/iN
 RaCu6YlhwrTUIHS+/9IzPDbt6nwVGBThPTJvCUMapVRUR8Ch8gM2QsmBc+OE0rgK/D2KSc9G
 ZcKTwp+8nW2OlRSApy7aUfbv3uy6jAfAFD4Mw90Lf7yAYnck4G80OXhnv+bY1Bmnj24M597M
 BjklhjbtMQdndlHJ70qwxTE51pkKc9Rw39lI07Wowfk65WV3btOthpdoekg8MgSYeDfROEVX
 bdYBTIpPiUO6cvnuAPqYSCP63AfAQB02hBIViP34g/YZJLStQzZkfZ79neLHfzsYe0oZj+/4
 /9Jei7hpCkGKGMX9Dn82+Ul38c56Bj0mkVb0b7+PbmuDLlmW4bfX5Q9fkhDQMFycy8ZG6rha
 IdUBfs6E7xRjZinmnwPlwO9AAuwItPSwDwWlnXL97N91eZ+Dgrv0CsLI9sMqCv9h4XSLIkxW
 Lrq9KLM9RPnYKJz/QjxspPPQEBimPuoXqgzaNX0xnAIGxOao06Q8b3AZzSTlcldiE2//ttgC
 sWEsz8juUJgrj+BxOUvpqmK3osr0FzWqwF/7q0tLt6/HR0zcZulCpxWryaAK85sT9g/R309o
 C8h0e5uUf+TeSELzNEi2xf6VtfdKtfO7AjqSeCRJjl1njRpdeH3ixWz9B24w/bnHomv0VlMp
 zZYiNSEqH0X1hLS58TGAvtw90usw3COgijd8OhZJ0Azm6fBbZknx787jJ0ItkrfWCTxnS3L
IronPort-Data: A9a23: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
 zI=
IronPort-HdrOrdr: A9a23:uPJhh63uBhztEz03xE7dmAqjBTFyeYIsimQD101hICG9Lfb2qy
 n+ppgmPEHP5Qr5AEtQ4+xoS5PwPE80lKQFq7X5WI3NYOCIghrPEGgP1/qA/9SkIVyEygc/79
 YsT0EdMqyIMbESt6+Ti2PYc+rIguP3iJxA7d2uiEuFJjsaDp2Imj0JbTpzZXcGIDWua6BJdq
 a0145inX6NaH4XZsO0Cj0uRO7YveDGk5rgfFovGwMnwBPmt0Ll1JfKVzyjmjsOWTJGxrkvtU
 LflRbi26mlu/anjjfBym7o6YhMkteJ8KoNOCXMsLlaFtzfsHfpWG1TYczAgNnzmpDs1L8eqq
 iMn/7nBbU315qeRBDwnfKn4Xid7N9n0Q6c9bbfuwqknSWxfkNFN+NRwY1eaRfX8EwmoZV117
 9KxXuQs95NAQrHhzmV3amAa/jErDvHnZMOq59ls5Vka/ppVJZB6YgEuE9FGpYJGyz3rIghDe
 l1FcnZoPJba0mTYXzVtnRmhIXEZAV5Ij6WBkwZ/sCF2Tlfm350i0Me2cwEh38FsJYwUYNN6e
 jIOrlh0LtOUsgVZ6RgA/ppe7r+NkXdBRbXdG6CK1XuE68Kf3rLtp7s+b0woPqnfZQZpaFC7K
 gpkGkowFLaV3ieevFmhqc7gywlaF/NLQjQ9g==
X-Talos-CUID: 9a23:dJdM/W3EHKEcR8cV7d6FdbxfMfonc3vAi0brclLjTkVlTJKEQHjP5/Yx
X-Talos-MUID: =?us-ascii?q?9a23=3AUm0P4A7hWkGX6iIIXN3Hx5UsxoxvsvSSGltRz6w?=
 =?us-ascii?q?YkO2DBTx3JjjFrw+oF9o=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.16,248,1744063200"; 
   d="scan'208";a="23377150"
Received: from 153-97-179-127.vm.c.fraunhofer.de (HELO smtp.exch.fraunhofer.de) ([153.97.179.127])
  by mail-mtaMUC217.fraunhofer.de with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 16:53:15 +0200
Received: from XCH-HYBRID-04.ads.fraunhofer.de (10.225.9.46) by
 XCH-HYBRID-03.ads.fraunhofer.de (10.225.9.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 19 Jun 2025 16:53:14 +0200
Received: from FR5P281CU006.outbound.protection.outlook.com (40.93.78.49) by
 XCH-HYBRID-04.ads.fraunhofer.de (10.225.9.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11 via Frontend Transport; Thu, 19 Jun 2025 16:53:14 +0200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D2cTynoEQTbszv1cnVTr62vmgHFCtiyutzxEMbcu9t7Se+t2xfFLHXxGdgLp92LsskYU2tVlwvPzO89/U+UZ+wclheJ9axMnM4h+8Bd+lW2W/WTCY1/d4SgulMYmkEGjBOZs6UiuyFsR2L0e4JyEU2YbYlTx0OFslOW+oE0mZ/n8QnPde1zHhsvPddXCGHK1qJhROR6cuu3AvAyalpbaxiZVIlMepAWBaxCNGbKQczb/7nBA4T0bEu7rxKNsonyuVm5dDdjLH0NtVg47qy8Z5Nqe41JaRBDeT6HKzG7GXWGISzOvNhu7YewPnREbeqbj2bYhLsyoXEfwqkNtyeTK0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CZfvJRmKoOKOtnF6yHYrD5tWcud0JZYaDfiw5Fl0C9A=;
 b=FuMkU5rQO2Y1l/9BRt3CgC28prZflM6F7mk2NYdvghtZe6cL5OamZPiEk+FAw43/A5Kn64SExYeBWYpVT+/xHSSQ2+hK2axrHmv+d1lOWJycKKjNX/puDnWZkJgBl1arVqlPyISFf+pI5i46nYv6b8ZobzARtWA4rrkrvb5Z2wBuqdi3aZ3no+uwkLldPLHyvlEy3ZKFcLRAxlVjVNsORo5VAsEy1IM9IrXdWlqUEtls1z6Jold62ezsGoSNJMDUZsMtGh78rNV1YyjCVTSSUxaXcLnXG7SDXqj/ztW9GIPKwTOXlXRmVheO9Q+TosUWwsIQDPhNAdbe+YKoKLn/JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aisec.fraunhofer.de; dmarc=pass action=none
 header.from=aisec.fraunhofer.de; dkim=pass header.d=aisec.fraunhofer.de;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fraunhofer.onmicrosoft.com; s=selector2-fraunhofer-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CZfvJRmKoOKOtnF6yHYrD5tWcud0JZYaDfiw5Fl0C9A=;
 b=U1LzXB5PSP+pMMjJ/OSJjvoKLk0qA5od3bySF2aJy2UOiRpkmjtNXUbk6xbUBv/nj7wcAdOCTajp7AC8OpFKa27PclPNLg9MLWd2soZ8+QbLkr+qwMgQOdx7Esh0YM0on+E8SMLyYh7OCP9lz+ydoFjJkDH+0aVrdz6LnFCpcko=
Received: from BE1P281MB2065.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:40::5) by
 BE1P281MB2402.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:42::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.22; Thu, 19 Jun 2025 14:53:13 +0000
Received: from BE1P281MB2065.DEUP281.PROD.OUTLOOK.COM
 ([fe80::81d3:f55:5867:1bd7]) by BE1P281MB2065.DEUP281.PROD.OUTLOOK.COM
 ([fe80::81d3:f55:5867:1bd7%6]) with mapi id 15.20.8857.022; Thu, 19 Jun 2025
 14:53:13 +0000
Message-ID: <8403cdae-bb70-4622-ada7-4b959dd4d33d@aisec.fraunhofer.de>
Date: Thu, 19 Jun 2025 16:53:08 +0200
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: <linux-bcachefs@vger.kernel.org>
CC: Michael Weiss <michael.weiss@aisec.fraunhofer.de>
From: =?UTF-8?Q?Johannes_Wiesb=C3=B6ck?=
 <johannes.wiesboeck@aisec.fraunhofer.de>
Subject: Maximum extended attribute size
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0142.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::15) To BE1P281MB2065.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:40::5)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BE1P281MB2065:EE_|BE1P281MB2402:EE_
X-MS-Office365-Filtering-Correlation-Id: 82b8fa25-bb92-4aa4-e940-08ddaf4103b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OFZ4SzVCbjIvUmJuU1RQSkVEMTZGL0M4QkQ5RHlhQU45SE90RVhua2VkYWNN?=
 =?utf-8?B?NjZoM29GOGF5VjhJNm0yN293OERKZUx4UWt4OGh2dWg1eCs2ODcwY2pqVGRX?=
 =?utf-8?B?MXp6VisyTmtaclVWeXVGVkwvZWp3UWdkMzRjemJxQXd5TDAwNnRKNmVEOG5k?=
 =?utf-8?B?SUhPK2wzMFZyY3lvcWNDcjU1akFHK0xSSEJGZ3pNMzdqQmhPR1hhK28vQUVV?=
 =?utf-8?B?c1BKaXlIRWpOOEkra3F0TU8zRzY2eDlhbHR6Y2pCSDVneTM4Q2hEdnFkYXB5?=
 =?utf-8?B?cWJXNXJFUDJtR0VrbHdXNXdFMUdXWmxodXRneU1taEhBdDhrb0VLN2VORjUv?=
 =?utf-8?B?MUMveXYzZitIV3M4ZHFsTXVuMlZrbHBLWUpIQ0s2RnNDdEJxSUdySlZpS1Jq?=
 =?utf-8?B?M2JnSHUrcjJucC8yRUNhaUprVXNFNXJSNG9XcVowOTVoQUFFU3RjdDJMbDZa?=
 =?utf-8?B?c2RZVDlaN29zdHRCL1ZmUDlvT1Zua3B2OW45UFZ4VGlPUW1DZ1M1ZmR2emtm?=
 =?utf-8?B?Skw0eW1oQ2JwOFc2UUNmOHNFM0ZKeDRKdnUxTy9EQkVuOFQvQmFjYW1hN0Z6?=
 =?utf-8?B?cG9qRktTd1I4U1dXZzRRdEt3MHg5a1RPVWU3cm05SXBBSWhqSFJPaDhORTh4?=
 =?utf-8?B?b0prdHBhMk9FVVN4S05RUkpkb3NSVWlqTkdnSFVqTFhYdlkzUXZDL1RtUlBZ?=
 =?utf-8?B?N3FMR2svVjdlenorM3B6eFZmcGI3c1JwL1NnelA2QUhZM2g5VTZJeVNNRmFY?=
 =?utf-8?B?T3l4ZHY1blZvbWh2QVhqdG9DbzVDenFWRk55WHNiMFpDTDFOeDBnbGp1L09F?=
 =?utf-8?B?R0xRTTh1Wk16ZllNK3FyT2RTdG5xWXIzclBPaFNMRGl4dzc3TFkycm42Vmww?=
 =?utf-8?B?UnpuZVRQeXlhSGhsUEQyYnF1dFR6QUhxS05wa0Naenc2bjRmc1ZVQjFxWmtE?=
 =?utf-8?B?dGxKdG53NC9yNXY5RE80ZkQ4UVJGcHowZm56UVVqTWc3T083N0RCVzJUQVZS?=
 =?utf-8?B?WDVPanpuQXkzVkNaRlRIK0dpbWppZkd4OHRtUjh3NGo1VG5GVzJTRmJ2WXZq?=
 =?utf-8?B?cGIyWkI5ZmtsalFGaFYxRmJLaitiN1l4QXpwWThaWGRHTCtnYldBMHNoVDhR?=
 =?utf-8?B?SmdzL0YxU2dxb1c2aGtNTnZ6ZStiY3h4VnB1V2hIV2hoQUJDQUxBK3RxMzlU?=
 =?utf-8?B?bU44UWxzSVprNFBhZjlEeDdzY2ozek9KeWdTMDZXenN6TWJpbklldU9qZWpN?=
 =?utf-8?B?aHBNMDRzZ1BRdW9POUthY0wwL0VUUkt0RlVITG42a2tFblFVekJWSW9HMkV4?=
 =?utf-8?B?SFVYL1V2bUsyM0tBQjduV1JNbzlLU24vWDd5djcwSjlXa1VWekpZOGEvaHJx?=
 =?utf-8?B?bzZGVEJQbkN0bzhuYzdiUC9PRTQ1eVk3ZTFIdkRkR0p3d1I0OGIwdTFsY3Iy?=
 =?utf-8?B?a3pVby9sS015REFlQlN4VFhHUFh1azBBeUtLbzNMeWlCell3S1IxV1d4MUdQ?=
 =?utf-8?B?SFNMWmdYc09EQXNORS9mWjNaR2RRdVM3SkFDYnVtU2Fvbmt1NFUyT3ppaEkw?=
 =?utf-8?B?clFWa1FoTnFzNmFVVm5tYWtyTGZ1UThacG5DYmtkWS9oazNRcm9GUGo0dzVo?=
 =?utf-8?B?SDdYVWdJMzJBSnUzU29QaDVXdkE2a056THRqdUxjZG1DdENUWW1FL1hyUW5v?=
 =?utf-8?B?RzBpUGwyQWhNL1FVYWJhalZKT1kvbmM0cDRxYUJnQWtpdWVFeSs1VjVTYllU?=
 =?utf-8?B?aW9aR3NFN3F4anJqbTdvaTNWbFl3WDdKNURTT1RFNXRQWlpuRWZxSlNuRGlZ?=
 =?utf-8?B?VXkyNytBcWpqMjJjTFNxVVJPTjFnenZEQk51aTBManBtbmwvZ0J2blhOL2Nv?=
 =?utf-8?B?WGtxUmVWbm9JT0hZNjJHeXRJVWpCTThhdUVCQ3RCS2lqZUhBSjN6TUxnOHBS?=
 =?utf-8?Q?Wptc+4EpOQA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BE1P281MB2065.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MlprUzdXYUVLbzUyaHg1eThQeTRCaVNVWXBqRFJtVTBlY2lFa2dJcjdhSFM0?=
 =?utf-8?B?dzBSR2JSd25tRUwrU3hKQkhwT0RGUFZOQmRNVnpDR1lzeXJvYUZQcHVxbTBv?=
 =?utf-8?B?Zk9nUlhJaXVESWpBaEZTNitxbzA2ckoydXR3aWlhVmFCQnJmNjBMcEVLSUhz?=
 =?utf-8?B?bHRyVG9vWU9TQ2VHOG5xaDE3QThFUDlYd2FGNk5zWGcrdEJmMVpXUG5TV3Js?=
 =?utf-8?B?cEE1cm8zTUQzVnB3cFEwSXFUMnJadEdiM1haQ21LUHoxamxjMDhuUUNramVi?=
 =?utf-8?B?cTc2ZVpqTzcrdGxQSFpidlR2RWV2cGo5NHkwU1pqRVBYaTMzS2RUeDVlUUJ5?=
 =?utf-8?B?U3BycDRXUU15eDFEbHpNOUV1SVJLaUg4U1kvZGN1SEJWTkdaZ0c4d1dNYVlP?=
 =?utf-8?B?ODA3bGNmUERuZnlNZE9QaEc4UFBQczhRbWdPcHAybkdudEF6bHdFRG4rcGdR?=
 =?utf-8?B?NjZZS3o0aTNWZEtTOFYweVlralBpTC9tN2ozKzNoUmdob2JZUWJ6WmVSY0lr?=
 =?utf-8?B?YjRLR0w4UE1WTit3aGdCbnN2TVFQdVlaNDl0ZWdyc0ZnemhTbkFhNkF6MjJ2?=
 =?utf-8?B?K1ZzZ2FXaUEyVzZUdEtsSXgwbFJzdmJ5QlU5MEo5UjdMVitpdmNmMUxZMXdO?=
 =?utf-8?B?L2tnc1pYa0ZpSGRqSWIxWVFmVnhaT0U0Zmd0ajF6RVpBUE1VVDA3M3Zpc2hO?=
 =?utf-8?B?WUN6YUwvbmlWTUpqVXZKaXFBUW5UK1RxeXpNK3ovOUdEWkgwTFBTMnlYUWlF?=
 =?utf-8?B?V0tieEgvZlhZTlhJWG5GbTlPS1dvdWZaVFBTTXBseEthWVVESzNmNGM5dGtv?=
 =?utf-8?B?WFNEKzZBUHlTNHRYaGF6bzFNLzg5Y0V0cUllQnJNcHlKbkRobUJ2L1dOR3pZ?=
 =?utf-8?B?WXBvOS9xQkxMWkRyTFRTVHNFUHpwSCtnN05maUFBQzh5dERGY1RNMDB5T3VB?=
 =?utf-8?B?bDZtRnlHM3NCT1BLVUNsVzJkL3RLTVdsZktYWTlBYXJCQU1VNGx0dnFCSWFn?=
 =?utf-8?B?djJOcDM5UGl3d0J2R3E0Vm9ZZXl6RlNmcUlTYzFLVTl2YTh2VUlHQ2xqZGdU?=
 =?utf-8?B?VUdENktZZ2hiVFRJR3BFQjF0ajlTYmhhMG0vTGRIelVBclZtYWZieW5tRFR0?=
 =?utf-8?B?MGV0MHUzbkJVNGdpRHRTZGVFMzNvZHo4eGJmdTEvQlpzcFBvQ1NRTEZJblNV?=
 =?utf-8?B?ajF5S0s3QTVPNENpZmRnWWJIWmJ2amtTWk9XbGFOQzV5b3JoRG9mSlMyV3Rs?=
 =?utf-8?B?eE80RHE5TDJEU2Ezb0tkemFHSU5VeU9kQTZJdUxBQ2x5UVI3WGdqZDJjM0Zu?=
 =?utf-8?B?cGI0R3FQcHowYU9nYjIyTTRraDRGcjRzMEQ0azBaR3lRL1FYZkwvTHJ6cFFI?=
 =?utf-8?B?VUdHL29wMWp6T1hkU0h3aGpNSUgwbjFlMjE2THVSTW83em52ejBxeFVtZEF5?=
 =?utf-8?B?T2xURTlvREdudlRMQnZUUGtvQ1VWbGZnK0x4ZFdiazRGWStpQk96UCswRlNL?=
 =?utf-8?B?YkVSTnVNeUt6ck9JNVcrTzQrNzRpcGhLdndPUk1CTDZXcmNqUkVCVDZYc0Vq?=
 =?utf-8?B?b3ZjOHVQQURJWnFNL3ZoZzdRZlpGZElsUis3ZktkQlJEdmkwL0lURFhycW1v?=
 =?utf-8?B?Z1VGWXRqbDVGcmtabVhrc1BKbEtubFMvYlFpcTU1SGJoMFBhczhnUHhmc1E1?=
 =?utf-8?B?cy8zbllYdGI1bFR2TkxsZUFWK2lzNDY4ZmtwV2pJK2FpZ0s0cGIzRHZNSUhT?=
 =?utf-8?B?VTRTdyt3WHlRNmFuSE9iemNMUlZHQWI3ZzFjRWEwT0UvR2N3eTBlWVphdktz?=
 =?utf-8?B?T00yNzVwQ3NYU2FGOWZQd0p5bC90RHAxeVRRNEc0UWg5cmdTUGVBTWVNOEFE?=
 =?utf-8?B?VmdwNTJ1WEc4Z0YxOWVXTTNWZ1h1cEVaeldmTThtdXVBV1UzY3VidWt2N3Rr?=
 =?utf-8?B?OG95RGt5YlRpRE43UUdPMzlqTHVZRk01TFo4TU5pdU1pNHRVeENjNVA2TFVr?=
 =?utf-8?B?ZmgxY2lGcmVQRXVnQXlKMXRnYU5PR1lzM3NUMk9vY0tRZm1PSXA3SjVKbHZC?=
 =?utf-8?B?c1F5bkNSaUJpeWd6V0NSdFBXamZPZGhkU0V3UndWWlc5NzNrWTU4TzgwUnVW?=
 =?utf-8?B?emJYVVk2bGNubGlqeFlmTWFmOW1Tb1MvWlpCS3lyTDFEVHVBeWZGU3VkV0Fp?=
 =?utf-8?Q?0KJxC+CBCeW8XK46cjqvNTvMO32xVxlP4rEtuvGEVPhq?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 82b8fa25-bb92-4aa4-e940-08ddaf4103b0
X-MS-Exchange-CrossTenant-AuthSource: BE1P281MB2065.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2025 14:53:12.9333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f930300c-c97d-4019-be03-add650a171c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ugtNdNrxpbLd/iXxYkRLx8gu+olVmYQr6rTBUhv1e+VuX1/XXlFNDBhjvc5Mgop+6ZXvHiFYhUVTNnxa/oJW+oe44zWvKadSH/mr0Yg0TU8sP7/OIk1Mq/8Nb7dDx0hA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BE1P281MB2402
X-OriginatorOrg: aisec.fraunhofer.de

Hello everyone,

while experimenting with large values for extended file attributes, i
noticed that in bcachefs, i can only set xattrs up to a size of around
2KB. This size is limited by a check in bch2_xattr_set that ensures that
the combined bkey+name+value size does not exceed
U8_MAX*sizeof(u64)=2040B, which would overflow the bkey's maximum size.
Therefore, the xattr size seems to be always limited by the maximum size
of the bkey.

Is there a way in bcachefs that allows setting xattrs larger than the
aforementioned 2KB? For comparison, ext4 provides the EA_INODE feature,
that allows you to store xattrs in a dedicated inode and, thus use the
full 64KB xattr size allowed by the kernel. Is something similar
available/planned/imaginable in bcachefs?

Thank you very much for your insights!

Kind regards,
Johannes

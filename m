Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2649A1DF27A;
	Tue,  8 Oct 2024 13:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728395483; cv=none; b=cuM1fxp2Cw7q5QUKOSIw1td/AsNTpHeUwlmmii7MVWjUo+Fi0yW897tlbr34Mh/fP1pQ78pBX01QVzDtcO2xFSo7HJUqmoeZIv8xkVPF9bi3577SvqTAk4wZJRTmCt+gL1OVUX5cphQoFH8sp35bREh4nN4OTJcVRCYHQ2ii7m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728395483; c=relaxed/simple;
	bh=VzJFo+8uqXUzzrk1WEUSIrzQWWSHt1xF+WPul/s4wcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o0dweKWeXIGyezii1m0LAtbvcr0/gihAOBnFCaesnYCgQyF1aoV5AopPCYrdE7EW2PcXxLy4ZRyeBlcM0TBG+nhfYjDIxsjiiYJxqC2sOo58ijoDhcm4jiC/Xyb9OmEAtJOOnDt1gxrQ9cNvH/J/VpsJ+6n2qE5zo/fG7UhaV3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iSM9ozmj; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iSM9ozmj"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-7c1324be8easo4805566a12.1;
        Tue, 08 Oct 2024 06:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728395481; x=1729000281; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1vzk3vCg0rxS9DOJpEPR6JO/PGgmLpGq1a9xYGVzUtc=;
        b=iSM9ozmj3kJMvZSMRERCQxv7swN77bRmDBaDPYcPZqAEnY5Qjp7r0aBaRsGz5xTHj7
         dQCApu4FUbPWMTzvWQqRCpyPQVwtjSoyo+gJUJw7gTc/IMgznD/4yMesqn20XxhTGLsW
         w45KWYUOAg5PtMwhNJ9rtapS/hLgEjjzw4F8Sc1xPUdGkFJGcFRtlW8iwCA6e3rhr+CE
         tkj88Vk4z6gXdE55PSK27oANy25/pizhiYSlBCw4a3aM3nRTbaS7and6iZJmKBzqcQ9h
         nwDN/JmLYwzy8PgjLiACHZRjo64kpbr85I6b3aaMXlfZS0xencEbUeGrPDCj82ghKes/
         PAlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728395481; x=1729000281;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1vzk3vCg0rxS9DOJpEPR6JO/PGgmLpGq1a9xYGVzUtc=;
        b=poDZnk5jnqGaY8iSwLVj/tlMXNABYy8hlPIZnyVGVgOPnS1kI2yEZvJ/YK9fX8MACL
         X8qOzSI+IT5itMi3feAIKKX1OcAZsERkpq2/Wyssg9F7gMCOf1emiSKsbCYLSYoAlMw2
         GKlrCPsPFPNm8VsAuScRtBpPdp7KPBj2yaKoqcoiqovyxV8rRkap3DFssY1OFG/2rU1j
         j0Dtt0Ezwzj4BvaoQ8gv9J+wKg/oJDkX1CQc0O+FobmLYHbdxns2snxnDw2VeIkYHqM4
         r72NoONkFAXMRPAMBoLMaaOBaYoi5KSyfYzJaGdcQ2oPpZziZeFMzPS4+6c+qDlv/7zC
         y4DQ==
X-Forwarded-Encrypted: i=1; AJvYcCVX/cXEBrSZeyN5AewlWOWMoJPygTq+I+QD43NCbahrxaspSB6eXuRz3tUNfGYTPrs6srjVWaQAxhcw8dUY@vger.kernel.org, AJvYcCXESUsbZ5Thdj5+xpURoQAPdf0EkFo9qORnD04ZgS1PpUARTb/ieFXAmxiEa86jH1CjLZ/Sv/gTbamUO8levA==@vger.kernel.org
X-Gm-Message-State: AOJu0YykabpoJR8qOTmO3SA88+8Rt8UmK4cnaHfED4beTIRMOllj/qRf
	36B/ssdP3tYa6bcIG6ZFDJZqfgdPQbxmkHETHW4jS0DrBV4EMa+V
X-Google-Smtp-Source: AGHT+IGj6j8eYFd8B7NmtYfswZhmSxO4Ztxbe61Zqh9QSjhnSsUJtGPGPgy6iJZqrwCY2HkAvvSfcg==
X-Received: by 2002:a17:902:d482:b0:1fd:9648:2d66 with SMTP id d9443c01a7336-20c5fb340c4mr1565055ad.17.1728395481238;
        Tue, 08 Oct 2024 06:51:21 -0700 (PDT)
Received: from archlinux.. ([2405:201:e00c:517f:5e87:9cff:fe63:6000])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-20c138cec10sm55769705ad.65.2024.10.08.06.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2024 06:51:20 -0700 (PDT)
From: Mohammed Anees <pvmohammedanees2003@gmail.com>
To: lihongbo22@huawei.com
Cc: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pvmohammedanees2003@gmail.com,
	syzbot+37186860aa7812b331d5@syzkaller.appspotmail.com
Subject: Re: [PATCH resend v3] bcachefs: Fix NULL pointer dereference in bch2_opt_to_text
Date: Tue,  8 Oct 2024 19:21:05 +0530
Message-ID: <20241008135105.7426-1-pvmohammedanees2003@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <f8fcc1e6-6de6-4d60-83a7-83e95a7d6b6e@huawei.com>
References: <f8fcc1e6-6de6-4d60-83a7-83e95a7d6b6e@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Hongbo,

> As definition, max is the right bound for value. opt->max - 1 is valid. 
> May be you should remove the equals sign.

This is not true, max is not the right upper bound when it comes to
this but rather the size of the array instead, therefore opt->max - 1
is where we should stop.

const struct bch_option bch2_opt_table[] = {
#define OPT_BOOL()		.type = BCH_OPT_BOOL, .min = 0, .max = 2
#define OPT_UINT(_min, _max)	.type = BCH_OPT_UINT,			\
				.min = _min, .max = _max
#define OPT_STR(_choices)	.type = BCH_OPT_STR,			\
				.min = 0, .max = ARRAY_SIZE(_choices),	\
				.choices = _choices
...

Here if you look at OPT_STR you see that it is indeed the size
of the array.

> It should be no problem to just solve this null pointer issue() (How is 
> this stack triggered, may be I lost something.), but this should be a 

The reason this is triggered is because in bch2_opt_to_text,
the parameter v passed is beyond the number of options available 
to Opt_str_hash.

#define BCH_STR_HASH_OPTS()		\
	x(crc32c,		0)	\
	x(crc64,		1)	\
	x(siphash,		2)

Passing a value v of 3 attempts to access a non-existent fourth element.
This value v corresponds to str_hash in the bch_opts structure within the 
bch_fs struct. Since print_mount_opts checks each option, it seems 
appropriate to add the validation there. Please let me know if 
I've misunderstood anything.

Thanks!


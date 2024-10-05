Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057E514884C;
	Sat,  5 Oct 2024 13:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728133363; cv=none; b=sLCD0zJKuzZ8NNez5iaI1wOgoEuNLp0hPjLeutnpUMPCvJtIvLoNdA3BaKqTqfSrzkvAj76A2KaOpurDMucESB0nyD0ETL+eDEjbwwdUxxTZ1XF+XtXV4PsEVgzfe450ofCoIinKcm6N9weg1WfAqINWjNFkKgQppmxTwMDl5rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728133363; c=relaxed/simple;
	bh=ZY+d7MhAztwIvVEagBWrn2xOpFQ0PqgC9xBBdBe0kxw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NoGbn/ZaALIxtuBfP/n4kSyVWW39+mgLq9eqJcZwNM43AMPdogJ6PJ/vrsolPP/60G4yM/M1KuknP8i1ksqHqWid6VDX1MayIC/nJiOkTX6rv8axm1zFfkx1DX2SNhGvmvN1nnM4MhdcnuFUJa4u2qcv/BmqdiD/P6yprZeZjlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KMTySzre; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KMTySzre"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-71df8585a42so163717b3a.3;
        Sat, 05 Oct 2024 06:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728133360; x=1728738160; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Z1u+AXQc3KShsKJXgs5fNJnOH5KwvpIrHXiX2ZuvgOI=;
        b=KMTySzreqo2/kVdK4NtVaWOC7itw2KqdbsUSrHAAEBkG00ug7aoNl2kWycJ83psbqh
         +MTYknzXwOtEUmY2CVB9CKl8xyfXnpYx9wQq5txWeIEpjjQc6lLrvfFO4cXH7hDwc7Wg
         gJZzTDpE7PJ1HoU3eaRGm3vU7A7f87CeHtZCte2KEZf0SoJz8zPf07NSKWhahvGSHrFy
         dPV+jtH6KO6uRVdHpJBxw7LROK1hfb37KnmnOZZJdwWcSvj2GjK65B5Vw8N2RICD/JGF
         2CtnOIWz2vFmHYoal7Si27FirZjeM1khZenF+RLEsSMfqRJk6m57TzJpfoX1CNgExbA5
         8yuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728133360; x=1728738160;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z1u+AXQc3KShsKJXgs5fNJnOH5KwvpIrHXiX2ZuvgOI=;
        b=BBjPquqmC0bnKzeE3WuFZXBKcFyLouuZqfGXxanDZLqJAFb/0xiLV6ezPzYkvxkEv7
         I9tewEiAhh87a5QebkzJqwq6wX/GDwDkacaEkknVDzPD1x+Ilvhz2PG9f3QFYAHVyOrE
         itlhqpoVRGCXIESRHTQFSptBt3EYYaJh29kVDCN0TRQziJ6P6+I7kq6hQ2gIogo63Wb1
         aWxoXNBrBkhLSByGWjJdSgFbEWkEC8TBix413oPsmD3/0aqaZ+kEMHlONPtUYFqAmj+k
         mZOVDcmx9yhG0rQNeDzNRAd1j7UrwxTmvq2r5NSIjrN22U5Jz3S1kEtfrKgDabH4P6HC
         rdlQ==
X-Forwarded-Encrypted: i=1; AJvYcCXYF9/JFHRq0oqsSAxUJ1XWvYkZfh2G/vdAiu6Ck35syCrOSdXBrS673/Zb2O86JZGJFbrmFuOTrpkQFAk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yya3d6choM90QFlF3lsy2/3NhKsv3auYrPT6KZOTfOVuiLOQWLA
	pkgp1336WEPSYT2agpSkqOpTDBNk6hzKtJJqAWRHON4AeeZV5brzyBRg4hRo
X-Google-Smtp-Source: AGHT+IE9BRwbL20vaX1wK+ntTJ+1n0jkM6UDK+1IYtndVsJYRETcsfqipm7h8akeMbSWanOaG0L2lA==
X-Received: by 2002:a05:6a20:6d13:b0:1d6:e635:5c5e with SMTP id adf61e73a8af0-1d6e6355d6emr3848295637.9.1728133360187;
        Sat, 05 Oct 2024 06:02:40 -0700 (PDT)
Received: from archlinux.. ([2405:201:e00c:517f:5e87:9cff:fe63:6000])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-71df0d46347sm1487896b3a.99.2024.10.05.06.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2024 06:02:39 -0700 (PDT)
From: Mohammed Anees <pvmohammedanees2003@gmail.com>
To: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Mohammed Anees <pvmohammedanees2003@gmail.com>,
	syzbot+37186860aa7812b331d5@syzkaller.appspotmail.com
Subject: [PATCH resend v3] bcachefs: Fix NULL pointer dereference in bch2_opt_to_text
Date: Sat,  5 Oct 2024 18:32:29 +0530
Message-ID: <20241005130229.9290-1-pvmohammedanees2003@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds a bounds check to the bch2_opt_to_text function to prevent
NULL pointer dereferences when accessing the opt->choices array. This
ensures that the index used is within valid bounds before dereferencing.
The new version enhances the readability.

Reported-and-tested-by: syzbot+37186860aa7812b331d5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=37186860aa7812b331d5
Signed-off-by: Mohammed Anees <pvmohammedanees2003@gmail.com>
---
v3:
- Moved bounds check above as default case.
- Removed the nesterd if clauses.
---
 fs/bcachefs/opts.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index 232be8a44051..84097235eea9 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -427,7 +427,9 @@ void bch2_opt_to_text(struct printbuf *out,
 			prt_printf(out, "%lli", v);
 		break;
 	case BCH_OPT_STR:
-		if (flags & OPT_SHOW_FULL_LIST)
+		if (v < opt->min || v >= opt->max - 1)
+			prt_printf(out, "(invalid option %lli)", v);
+		else if (flags & OPT_SHOW_FULL_LIST)
 			prt_string_option(out, opt->choices, v);
 		else
 			prt_str(out, opt->choices[v]);
-- 
2.46.0


Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5774C188583;
	Sun, 22 Sep 2024 01:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726967914; cv=none; b=ZZsE42Bz+5jfFmep2S1wZqgotq/hLIybCCGJ/n7PVjyZoNeABUKtmsPDzgdvnSu4DOh7vw3BsiMJJRP+uXFejhJBl+6oUxq9FYBkCRFkMhrF7Bu//S0eHylaHICo0aCvjZ4dFIGPMfAsJmI9fRR88CvPFqopk0r9AxsFeW0emTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726967914; c=relaxed/simple;
	bh=nSc1dNVGiq5OZhW5jIvRdS/5N+mTR8NjoXTriwoUOL4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T/qVZLXlO1PP4X+vWRc/741/6x4l3lV8xdbAq/qXxzb4ra3PPpEfoF+lcTNpOVjHh6qulkP8lUvgFOqIKjdq+Z8+kvPAL7VcxF5ZWLPNMR956+G/lHPc3MdcFlndS+GsR2hpppgqhro4iBdndN1iIg0yZ5xsWPg150u0f/d25Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YxOTBfXS; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YxOTBfXS"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-20792913262so39472755ad.3;
        Sat, 21 Sep 2024 18:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726967912; x=1727572712; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=d+WTUQ8sgjvW71xt7bjz8TZx5pxuET5DBRHLzcuifYw=;
        b=YxOTBfXS2SqUEx9EgUVFKoqlgx7jYDE0HRLs/2Ej8Pd18UrNFafAdBH2KD4eI9SOXm
         zdQOnLe90skoDvxPUKlWOlc1HPNDezVOfuu3T2zzGMeNPiTPpntoQEO2BvUhpBS7LP35
         rO7YLSLOfzKI9Ul7cSqKwg630g05OM2M2V47kqm7cPqNVuqkYMAJSNIHmYwaE/gwd8oV
         0CBupypHWpMbFtwvJuh6vrs2/sZGnjH1Knc1MxXmFlW739aN2uvPhDMR8B+XZB5yWAud
         scFVnA4l/S0nVty+1Sv4HGghgdJOtpJecHi1sbXZojWvTzPeq4lNwEkcAxFkW4I0oOhn
         jCVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726967912; x=1727572712;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d+WTUQ8sgjvW71xt7bjz8TZx5pxuET5DBRHLzcuifYw=;
        b=EmUOTmofDhxz58kzwRdwW96wCJ5lcIZJhLDSXGxMAqsBCz8sqqYhwZjlf0Rf3cA9Vm
         nrhDR6un5kYG8dEFnP1tVkEwXVn5Q1hqcqfqkgikin4Ituooa0bS91JBZ6Bbxm7m2dhb
         WlNwKyTDyYVQqFaNK2ii/YYzyozqhqn/ng35u/bR7ppzOfXSrtiHSniGsa7XX6ufxDjj
         fuA++zfiTwaqvW4yik5hOZ7bmNPHWGm7CsEHqZMS+aCPQbsUr/dPO9PQJ84xqVTNpwCO
         NH6005EeQQkzi4n06zNJvzRWXVV3W11PDOcaRe2YkRCMNBKp6/TKCjlmpZCg3JHeYrRs
         8EOw==
X-Forwarded-Encrypted: i=1; AJvYcCWkAyXExfDyG/w/kueJrkzqONiCUaEdWPHU88JmiyURGc9JvrfsgYOvQ/OcxIj9AH9Ey8M9b9FPDDE4CWA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKiNJcUIPmR9EMOgNbqeLVLcuAfuIYQFUciiwiKqnjPOo0eKrE
	OpCBwGqZqsVoA0iC4Sy4DmpGeJ1577DeQ/TdSe3Kqd5QE5nuAy76Q81H1ZCa
X-Google-Smtp-Source: AGHT+IGCdQMZ8mo5nHCizSiODxLohssE1su0F4Os2u4u2j73a1MVj655D7l5yhCO3/EWLObyWL0zhQ==
X-Received: by 2002:a17:902:d505:b0:207:878b:c37b with SMTP id d9443c01a7336-208d83ab624mr123901695ad.30.1726967911609;
        Sat, 21 Sep 2024 18:18:31 -0700 (PDT)
Received: from archlinux.. ([2405:201:e00c:517f:5e87:9cff:fe63:6000])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-207a09593f6sm104181375ad.220.2024.09.21.18.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2024 18:18:30 -0700 (PDT)
From: Mohammed Anees <pvmohammedanees2003@gmail.com>
To: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Mohammed Anees <pvmohammedanees2003@gmail.com>,
	syzbot+37186860aa7812b331d5@syzkaller.appspotmail.com
Subject: [PATCH v3] bcachefs: Fix NULL pointer dereference in bch2_opt_to_text
Date: Sun, 22 Sep 2024 00:43:07 +0000
Message-ID: <20240922004307.8020-1-pvmohammedanees2003@gmail.com>
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
- Removed the nested if clauses.
 fs/bcachefs/opts.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletions(-)
diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index e10fc1da7..1d777b332 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -418,7 +418,9 @@ void bch2_opt_to_text(struct printbuf *out,
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
2.46.0


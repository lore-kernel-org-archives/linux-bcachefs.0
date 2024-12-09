Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64BD1ACEA5;
	Mon,  9 Dec 2024 12:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733748889; cv=none; b=JIRB20jK/vnasXrHUL3uwxc9I+MEMqaAyte1D23HvYpFxIV4FyatiyvLV4GXV5PjIabX1zPuYeDRN95+hHb5ynFYiYK8snWCivpv/p7xsaJjsvBo06LbnLdHzCUh9mhi/W8qgJoGU/oOnoWW0sx7VnpzgvfI5qdRblO3y9Dabtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733748889; c=relaxed/simple;
	bh=4GfmLQRORREWsphDbK7jfP5V8JjOElJ8PJxq0x+tTIE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Fn+/QdJmos1RU0UWX6av2zVTxdvySvt3i1GZbvg0bcQ40cTISFYIZ2JnrXF4ZtVeV5Mm68Gdxeth2po3aWrR9mgjmVnIUxidr2CSJuIV8ZzEJBwKzm7qzpxOfxe0DKn3+IP+p5c2XhB1r2lTssVNqPmt78D6HlU1i6DDAgaGr0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kiKXbHG6; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kiKXbHG6"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5d3ecae02beso1796169a12.0;
        Mon, 09 Dec 2024 04:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733748886; x=1734353686; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=U5GM2+34DCCYHBW+8OHVhcRHziu0swk9g0Fwnp0z8gc=;
        b=kiKXbHG6RvLDz5h7vO3ikBgUM93ebhokVV0JJPpwaGJjrgZ41ckBB55oyNkVO1k+Fg
         I/Ywc48pCgjb5K2N9cVmiWgtvNGIJdY3HY/ZMfctbStPiQ+H1UJfMmSnHpUhnueK5r4W
         o7fqE8/7fDkfNzzbabTCWwtjsmGbGq+yEDmx9/h4XEeUjCHrLUSMzSPM5WefeCvBL0ar
         Bo4GGR8ZbIppFziibAOApKCEvxB42cBo+qa8UemaYTZ0tqOoN5pUUNfz5Rvt9T83JLsb
         SBsVUDJCik2lZwT77xS8oVjD5KgrJtBwVWtpuiyYhb9OFiZhGzXirLfh9hYJ6wafDa9H
         gtIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733748886; x=1734353686;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U5GM2+34DCCYHBW+8OHVhcRHziu0swk9g0Fwnp0z8gc=;
        b=vWcd29ycZx9JyU4DH8oTlqBMn1yPSE6ng1R2+HCNVY0tW1np2fLY2vblJTsuA6GII3
         mWLesM7Llq5LVI2MdBr31zkUylk4LWqY49povDs1hmDun1sTh/7MWSLeoQ0PIU9maRXi
         yP5bkSC5G0u71I+fIKEHrMR6jlrIdZPDWA8D3p+hQuyE5iXKLKsdkAHsRwKVyWnCZa9h
         aveWnDAvlnk7kO1tPijVy7BOYLgWD3MJdz4nISlBgakB3m0Fln1+PFYiDMXlf8jzY/hy
         9adSPl1tWknOap35inI5ZChPyL3U9KyAAW59D2411E7YkbFjxVyU7qm8zne3Y+jcoQb/
         LDXA==
X-Forwarded-Encrypted: i=1; AJvYcCVgGJJvFaKHexSoXdgdlkf9GABgBkeOfaDkLDaraSOAqN7K73abHFnSn+78jG9oHkQKkefbPs3ndrHCaMwbVjE=@vger.kernel.org, AJvYcCXAwPTvuNINL5ECByBWqcAfCmDywaescoMf0v2ceAzsK9xu8+nB1+OzneagVENatZQuK5lzRuxsDNRiB4wR@vger.kernel.org
X-Gm-Message-State: AOJu0YzyaSrcUiiUQ765kXfDMw7IB50+SXSTMNd+wCbBaNzwFfIZ3i2H
	0JAtlW5A826RPJA7x9tlLBBc0XciBboXkaRKFR/5ugeZKANSlX0DqK7KRzW4
X-Gm-Gg: ASbGncsGXClnSEgBShfssG8UCo2Trb7J5LMuCKS0/ag4cIt9d4Z3wviEuVpXj5E1kPi
	GaaTnt/iFQxAOZJJoXKJaVDzk8hWxYu7RVbfhNVDt5newc5dzLMOnV+vGtImw4yRRRudROix857
	frpM4XVFe6kAb2P8yhlqxXk6RH1HDkeMMSBF54wICujtWmG80BDnXE7D4a1BZ32LrMfltd7waAg
	eb4ZFYAZnMmQf+B0vwcgvZuCNOKsEJ8wbjcU8K7wswP
X-Google-Smtp-Source: AGHT+IELlhBR7Z1TDXEb6J4IdJfU4PcZH3VcLVrzIjvnvx6oJ2/36KLlR7mHoz8KCkwiaHcdR+LpLw==
X-Received: by 2002:a05:6402:4007:b0:5d2:729f:995f with SMTP id 4fb4d7f45d1cf-5d3be816a47mr10413658a12.29.1733748885830;
        Mon, 09 Dec 2024 04:54:45 -0800 (PST)
Received: from void.void ([141.226.13.92])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d3d76f3892sm3899186a12.28.2024.12.09.04.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2024 04:54:45 -0800 (PST)
From: Andrew Kreimer <algonell@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Andrew Kreimer <algonell@gmail.com>
Subject: [PATCH] bcachefs: Fix typo in bch_err message
Date: Mon,  9 Dec 2024 14:54:20 +0200
Message-ID: <20241209125440.10327-1-algonell@gmail.com>
X-Mailer: git-send-email 2.47.1.404.ge66fd72e97
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a typo in bch_err message: Hava -> Have.
Fix it via codespell.

Signed-off-by: Andrew Kreimer <algonell@gmail.com>
---
 fs/bcachefs/journal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index 2cd20114b74b..471c6a3ffcd2 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -167,7 +167,7 @@ journal_error_check_stuck(struct journal *j, int error, unsigned flags)
 	j->err_seq = journal_cur_seq(j);
 	spin_unlock(&j->lock);
 
-	bch_err(c, "Journal stuck! Hava a pre-reservation but journal full (error %s)",
+	bch_err(c, "Journal stuck! Have a pre-reservation but journal full (error %s)",
 		bch2_journal_errors[error]);
 	bch2_journal_debug_to_text(&buf, j);
 	bch_err(c, "%s", buf.buf);
-- 
2.47.1.404.ge66fd72e97


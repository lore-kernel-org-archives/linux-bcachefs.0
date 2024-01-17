Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E95C134BD
	for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jan 2024 09:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705483410; cv=none; b=KGm4UQvTzFBOxkQjsk4vGB5IbjOJEcwnpqz4OCHjgn6B621EthFr5QHmHlQiCGuDfUhhuNccV6C0dLMiFSpLk9eAD4gn8qeaA9x2bS23DLas35bCxSqryF9zqXMNvTmuPnl4bHHN3Mj+xNf54WowG+DUMRpG0fhzBHuiTZqT6Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705483410; c=relaxed/simple;
	bh=BDh6mB/SB2Ipz+kXhSEegtCxOz1NHJLe2CHNIpGVoyo=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Received:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding; b=rAvYMqmO2ohVYhbBIyDeDfQJrErTzZ1lcoPhWYEYmEwj39+Gus6DvtgfzexW1McqoCc3oLzDZKAQFtiVgvWPxyVBnlP8XgfigD0NrDKJLdRWXt8kyhVDccDikgu6HwQr3vhAc2XXSIP1gGVNbhjHw5toYN+/nZv+BtCLlr3InoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BhTDOHcL; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BhTDOHcL"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2cceb5f0918so113572841fa.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jan 2024 01:23:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1705483406; x=1706088206; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XkxyCEhENPLDVSdogBFfOHO8z8Jg872RrG1kJpGy2eI=;
        b=BhTDOHcLU3N67f2pxvraB+AMAeBl3HO3xRp2PxqX/1nZyoyEt6u0i7f2dDxff9BNbv
         eylbz9GyJx7qhA0D57S4aduPZadmYgMwjwPlTJm0x5C3o6LWkHNqceyLZKLjqHFJa4j+
         OjJkPzTMfLaGsphckyBfX1lyxHicgQJK0DQzALWGXWmuMBLW1gA+gVGvwafFjptyZdla
         6cNtF6Z19QhTN9YZ6UL45nWWK7/6KvPghREC/0LUfZBBAF5sexDuuXHZcJPHdQJNUVSy
         W2U7VHaWvNrSi3QSvRolXYWheWzIw2Pxm9boJ9dAt7sRTHFNv3k5eFqwf/Qu0SPAHa04
         62hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705483406; x=1706088206;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XkxyCEhENPLDVSdogBFfOHO8z8Jg872RrG1kJpGy2eI=;
        b=FgPvAtNGlAp+cz3g4Bdmnnz2dh9Qm1gpe4TAV15R0icOtUmhtNeOXV84MFl8nbDBX2
         Dh+stgMLVcAliF7aesbq6eVCUIM9h7N0H3enJAZlJ8nOrdAk3oj9JymBMEX1JcA+Dsrz
         mJv3CpCNZRibMZhh7U85fMtXl0LQYeWh4+nexR6OhOngpjvh0KLTsnUv2z8zidVsaiQk
         6z8OTkvBV0Ya4DyQhFf2jEOX5X2PlngkZ3Hdtn1y6BuOOu6VWORPrcdOj9d9x1pyGiuK
         HJO9vZVr046BvuWpzeaFr2pp73+qwh9lV+0P9amxX/ME5e6iKbkwkwvpQwAAtBIhXlRO
         OV/Q==
X-Gm-Message-State: AOJu0YxGVZycrfODqZ1CwJuBMvj11cFmQQbuwLRmbSsvjReoormPYZPC
	IpoO2+3CcNN1SXUtDvw23FtpWT/H40nZ0Q==
X-Google-Smtp-Source: AGHT+IFKKQDeBO7Dr8rDB+IcBTSTJ43RzgUtfD6oilk1sO5Ug5Zgs6atHBvJd1+cNqN7u7IYf7+Qpw==
X-Received: by 2002:a2e:8447:0:b0:2cd:7f14:9b33 with SMTP id u7-20020a2e8447000000b002cd7f149b33mr2401318ljh.51.1705483406318;
        Wed, 17 Jan 2024 01:23:26 -0800 (PST)
Received: from localhost.localdomain ([23.247.139.60])
        by smtp.gmail.com with ESMTPSA id d3-20020a17090b004300b0028ceeca04a1sm13736472pjt.19.2024.01.17.01.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jan 2024 01:23:25 -0800 (PST)
From: Su Yue <glass.su@suse.com>
To: fstests@vger.kernel.org
Cc: linux-bcachefs@vger.kernel.org,
	l@damenly.org,
	bfoster@redhat.com,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v2 2/2] common/rc: improve block size support for bcachefs
Date: Wed, 17 Jan 2024 17:23:09 +0800
Message-ID: <20240117092309.1134595-2-glass.su@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240117092309.1134595-1-glass.su@suse.com>
References: <20240117092309.1134595-1-glass.su@suse.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For bcachefs, def_blksz is never assigned even MKFS_OPTIONS contains option
'--block_size'. So block size of bcachefs on scratch dev is always 4096
if _scratch_mkfs_sized is called without second parameter.

Add the pattern to set def_blksz if '--block_size' is given in MKFS_OPTIONS.

Signed-off-by: Su Yue <glass.su@suse.com>
---
changelog:
v2:
    Born.
---
 common/rc | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/common/rc b/common/rc
index 31c21d2a8360..6a01de69cf05 100644
--- a/common/rc
+++ b/common/rc
@@ -950,6 +950,9 @@ _scratch_mkfs_sized()
 	jfs)
 		def_blksz=4096
 		;;
+	bcachefs)
+		def_blksz=`echo $MKFS_OPTIONS | sed -rn 's/.*(--block_size)[ =]?+([0-9]+).*/\2/p'`
+		;;
 	esac
 
 	[ -n "$def_blksz" ] && blocksize=$def_blksz
-- 
2.43.0


Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5648F7492
	for <linux-bcachefs@vger.kernel.org>; Sun, 14 Jul 2024 20:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720987387; cv=none; b=D/QbppEUlrbdhwHVCg7fsNIOaiefs1IsAsVKQfcjjlB7DwJVKQKXpklctp9ddvmvmSdH5ASvYYyZC6kVuGqYmXZv3IehYN9wZ2KLgVpg969p9WrmJvfgotqxB1qzip5pegJAsqFFJ5FWHjBdU1eqsUzFAzFndh2x9wDgsgSeB/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720987387; c=relaxed/simple;
	bh=brUkYp+YcMWJgHwg5ENw4dtWdokAHJq2pN8VHt9y1xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G9+1LNclPUDW9jdC9v2GhQN4gJh0QS7xUsS39nYlrVC9Wz6PvDckGCHmprEUJrDe7g5jTLhUEt5xcAJ92Z8l3uGtJkMbPMosFU0m0MbEL2UScPvagGsBTfEsBN2lGqM1SQPe3ejUBVhevk3E7GCuGcEFmEPstsqmgZ3Uzx750Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G4i5qe1E; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G4i5qe1E"
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-7fd3dbc01deso175116239f.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 14 Jul 2024 13:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720987385; x=1721592185; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=65j+NXrzsv46zQmCTAD1VxoXcZdLzTsB7ecIy05JV7o=;
        b=G4i5qe1EaNu3yVcs6owHUrdDQ1iO2roq2UXxVOTYZHbO/ta3AHzmVE1XIT81jujvcb
         zhXLE7L6EK/E+u7hzDySscEjxhuol1Px4XX8ckkn2vcCA5SBztoTwd5bk+2EOXu9kazA
         mCqRixIpxlrXUWKjDTxIc1BJT7a6i8vWuQI5tc0ICcn3FOOVsV1kbTOBWWDxuojT8dib
         4sMhZBnKNxTNC52esTNpraRq0Z+R/185wICdMvAElLU1GHMRluqmZunzD6AitsomPs1l
         9D6saImnJrm8fAn0iWRXTqD9tbIl79/auO5RsqFjNSSL9Y18802CaqoiCu94KY3mINkX
         HRJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720987385; x=1721592185;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=65j+NXrzsv46zQmCTAD1VxoXcZdLzTsB7ecIy05JV7o=;
        b=w8JH4EJrw8AmeQXFksglkmDTQbtwX+AVLXbBHxA7WsU0Srn1cR0F4P6Yj0ozLd4dsE
         GG5uvBwZxGvLesifVKJR8Vu6Y8PBxpcEWkWtIJrgW5Vosx8U6PWpuH81CL1C5QwGxlz1
         Dfne1wuJy3OR3GR1vXOcYhylHP8M/M+hD6rNV1HQRQ4futZLroyjPu1n6NbwYol0LZQY
         KQ6udLEe1os5M12+2ifsc/FD+5U1GoXGGr5BKW7pxu9QfP9eE0CzTiJnxj87Za5FPY0m
         NdYKmXHRP/Klbr138eqe/NjH4QObkkRWz6BPN0dU7CE+ZtkXhuYhZZ7zl15x543NGRTA
         ZAIw==
X-Forwarded-Encrypted: i=1; AJvYcCUQHPxdsHsXYZDU5TiRm3KtwvIqrUJL4lhUa89q6w/J/9x5Vzokcy0hynShdvbIedrFG3i8zjV2x8ZdLrwOakxbmkDKGkNaO0UhMnQO/Lg=
X-Gm-Message-State: AOJu0YwdPaxE4igvLOnk+GE/LCiRskB4rjeXuS1E157BgQr7L3zRgmy5
	hbILBMIFpSqvLcdlr7rgFiTEd7fEiqrbpbxVXzeyB36gwZ9CamOn
X-Google-Smtp-Source: AGHT+IFRFlnNJgmN1BJBIFR2rBylktFoebBLzp56zlHsJA6X3HuL9dBv6L+nPG72ZwMIi/jBil0T4w==
X-Received: by 2002:a6b:e603:0:b0:805:3d47:19d6 with SMTP id ca18e2360f4ac-8053d471a16mr1400128839f.6.1720987383490;
        Sun, 14 Jul 2024 13:03:03 -0700 (PDT)
Received: from fedora-laptop.hsd1.nm.comcast.net ([2601:8c1:c100:1c70:46d4:8434:9d74:6efc])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c1e1b2cfb8sm892815173.62.2024.07.14.13.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jul 2024 13:03:03 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH TOOLS v2 1/5] include debuginfo in bcachefs binary by default
Date: Sun, 14 Jul 2024 14:02:22 -0600
Message-ID: <20240714200226.746471-2-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240714200226.746471-1-tahbertschinger@gmail.com>
References: <20240714200226.746471-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The debuginfo is used by the "bcachefs debug" and "bcachefs list_bkeys"
commands.

Rust 1.77 [1] changed Cargo's release profile to strip debuginfo by default,
but we always want it included.

[1] https://github.com/rust-lang/cargo/pull/13257

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 Cargo.toml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Cargo.toml b/Cargo.toml
index 9d1756fd..d56d6272 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -30,3 +30,6 @@ zeroize = { version = "1", features = ["std", "zeroize_derive"] }
 version = "0.10"
 default-features = false
 features = ["auto-color"]
+
+[profile.release]
+strip = "none"
-- 
2.45.2


Received: from mail-dy2-f43.google.com (mail-dy2-f43.google.com [74.125.229.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97D03BF695
	for <linux-bcachefs@vger.kernel.org>; Thu,  1 Oct 2026 15:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790869647; cv=none; b=asa6EKki+5y7j5bXLlS6PcBdmzRXpwFfyM098lcrihITUn45lVDyAvT/CvQtciDRzIvIYoxsIDkxj2dN0gYE/q7hiX2lQjLVHk+oG9kEYqw91/xqOLcngiCZ4/jDoN6TvUnWrpbYjw50guudWUXDYqYL2Z58/iA+Y7ypmQejrIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790869647; c=relaxed/simple;
	bh=Wu6Wk/A/vTOlHuEwtoc0ZP9pRT6pjg12fIKG/NCNSgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QYHaObdWSdbc05adAAkfompUWDb9/k3Lykg7OMEbNwbByxIhnuSPGGWJ5IeEv5jfnBQGA51kYxRvh/gdhINqOBawVAQx7BIBX91VAFNDJ6VJ+GhZomz7xUOTVMjJW3ihUc12fIlcNx9oIlo+rGwvbJlvcXoSALwpTbOT3Ej9oeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=itTIh7HZ; arc=none smtp.client-ip=74.125.229.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="itTIh7HZ"
Received: by mail-dy2-f43.google.com with SMTP id 5a478bee46e88-33bfb26865fso6573040eec.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 01 Oct 2026 08:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790869645; x=1791474445; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HfWyL3ah564cAYqGxuAzl93JjMaSHm8aiO3CimFN6tQ=;
        b=itTIh7HZBbC/okU39o4P5+eYrH8wcODdqW24bgKAzZrYkd4LDQVUxI8R2gmUMX46Ka
         kQAUGRUWbTnJ/X+jTfJCHWvv0+UpO+Bx634I7ZcH2JGsxt6YE3ojq7CVx9lRp8+ZDaQb
         KSWY/i34z2ORni0I8alec3N0ldZZtjri7w0iHYFJ9eEnYD/b105B7kqHO56cEO9yxSpu
         IzZWs2DQM+/xZwABJQr09s8NHWcQEqXq26pLdRRQWKakxPFMchBzs0Mm1ewDdaxB4kVD
         tqMR+pXcbiawSAeTzq8vdfwlEPzbEdV1eItWNeKM7VocVJrBAqbWUUOiRD+pP9yTMXj9
         QT4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790869645; x=1791474445;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HfWyL3ah564cAYqGxuAzl93JjMaSHm8aiO3CimFN6tQ=;
        b=JGQoksVnHj/rsP7yIRqp2tzwQ4JlncZtUbRhAoQMV6AIIqI9Jl4m46sb8ZxWd83P1m
         oAL/r0oRjpW3d3FqNIjRut1TwYC7QZPmcH9gdH7pnST/ZKRlz8M3KmqtxG3CJe3F4Pfc
         gOHFFAXcnwMLv1APbf1FA0R72maD8NbzzCSrbdJ5x0ntIgpSs4UTXVnNBipU6FWjUNnm
         jmWc+7C/oEXbhRF5+Wk9hDMZYXojTJ6XcFNm7be1wbVUQTKU+J0q7A2Km4mdUB1Z3lEa
         t6JCmffmLu6ViVvzvAV+14NyzeeHX8ghiZg32D4bR1fNMfVyXDsY7raA0wP2MkLwEBDM
         l54w==
X-Gm-Message-State: AFq9FYJiszi6+jek6hs3mj6u/3sQgkFATnqkSIJ0oTVXtx+JMuWM4bfk
	hNGxsfpI6xYFNAhjHta6gJi7HZwkqT6vABfsr4DpRzKwmk3ApIrGzi+e
X-Gm-Gg: AYBFou0CU9b5gOsCRZQBpaZ41UjWGFcrzshMaHQn3g0attoV2QbsR2IVq/rs9E+WO3m
	HDt9maWJ0WmJNtfj6v/eDn8NAABfylOtu44MkLg8ZA1OPBsss1GpM69D+WC19ldJgEWEKslVHh4
	8XyvGVS2azpdGdbSvzNgCfQfqQVSh+eNDj608uWe0C02l1nWFtJkIbq7XOBzk4+a5EdZMYrQUCf
	BVXR/Ma9vi/uXn4PXiVy3HpBEyjZ7DstL4pfBDCvUr0pjwzueWj8z1AQdw4phigt2xGaR+6NkwF
	C+sUayvd7lEdYw5IxAsh5M91OFIbBZ9uRweLxgoT7kEJbTrCLHmJ4yr+9CYCMABbXIXNQUEW1e/
	GzaCoxEvD57TN2fhz0Tbj8J/CVzQJ4sFUz9G7UcHO0ihUnz5jkgxgxaCpxlNCMWO/vxsn2RWc55
	3Hc/6HZJjZxcjotK7kyqhU7FIomJbyNGsg/1v3UQeD3KClaHBz07Cq6rg00qw7DrVqlNJ2TO5xQ
	j9FTyErGNP8Hft0cRmsrV+W40jQMz09ITeLcw1+NCrlPPE8pwkpUFdo1gfMI+CwR0pYGOxgRrWA
	YZ8DRQ0KOHZFGmViobR0DhMqL/POSaknOsdXeP9ML6Yc1V6vGOg4Xv/GN0GqaaSdOW/ROw==
X-Received: by 2002:a05:7301:152a:b0:34e:f7cb:605e with SMTP id 5a478bee46e88-34ef7cb6f62mr37490eec.35.1790869643528;
        Thu, 01 Oct 2026 08:47:23 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.6.151.236])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34db491fae1sm8557575eec.24.2026.10.01.08.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 08:47:23 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: J B <jb.1234abcd@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: dkms-bcachefs-build rust error on ArchLinux
Date: Thu,  1 Oct 2026 23:47:19 +0800
Message-ID: <20261001154719.427562-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <CAJXMFhEt=9hGnYaFHDSPLZYk3BWRudxW0M=XTpiFuoH7vaz0-g@mail.gmail.com>
References: <CAJXMFhEt=9hGnYaFHDSPLZYk3BWRudxW0M=XTpiFuoH7vaz0-g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

From the make.log in your forum thread, this does not look like a
bcachefs bug.  The failure is rustc error E0514: the kernel's prebuilt
rust/libcore.rmeta (shipped in the linux-headers package) was compiled
by a different build of rustc 1.98.1 than the one installed when DKMS
ran.  The thread shows 1.98.1-2 against 1.98.1-1 in one direction on
linux-lts, and the reverse on 7.2.8-arch1-1.  Any out-of-tree Rust
module would fail the same way, and the bcachefs sources have not even
been compiled at that point; it dies on the vendored bitfield crate.

I have not reproduced this.  As far as I can tell from the thread, the
fix is on the Arch side, as seth and stronnag say there: install the
rust build that your kernel's headers were built with (or wait until
the repositories agree again).  Once the headers and rustc match, the
DKMS build should go through.

Matthias

Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E469E1F76B1
	for <linux-bcachefs@vger.kernel.org>; Tue,  3 Dec 2024 13:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733233336; cv=none; b=d0BYvCQDjZ/KWUQJvjEU2NWP07fbyJ5/Bn671Pt/XvgDOVlckppdUiehRgHZ7aNG5rS3keSZhy1/ieUUMDDGO6eYgvV70HJx6pvcswPWXnGsvNDVfcB4Ws3WSPIC0OvwN5kxQ20N7b0+dhI+hdTBLS5kWy07Iy6CClxWco+LKqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733233336; c=relaxed/simple;
	bh=BPqo/+vJ9OA99wMkdAF6vWPVOkXo/UQOziFQPIlW/1E=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=P9NsK3qzrJ/I6iqvSdjcmc0NXHRWouELVBq3vCfgWEzYGnBi7pIWl63QvfIxXDlFxfVdanWDSlXr/Y2ooE+vAJg7OUG6n90ZtoH22es0CD6td2jtPrEtbbzT3rpQR7V03rLuZLOZ1tDMNe/m3UO71yF9Hf/tZqtNjqz/O3wm4ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LjxLmdEk; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LjxLmdEk"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-5f1d1fdb328so2090701eaf.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 03 Dec 2024 05:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1733233333; x=1733838133; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TPziSiz6FIPz1llFZL4/mtv70ocOZmo18hfdyDsh/VQ=;
        b=LjxLmdEkeOzRdv2LOy8MDnd9IqaiNPf9AwmUCLMdGor82amWTMEVsYs886T7eymnrB
         zy8yYZDY14DZBsGdWmoreADl7hEbgNxly+iMObL2qjPO96HYxRFEMFESudSPrIrCorcR
         pN+ddZMBHAZGjOilYlZu3wGLqsmLvLhmRK6B6WTWkWx+Gwg3aJwrbmEcJtGqStUMLWo4
         5rFsmQDKA5/pJyD9px7Z8bfH1jM8OQvEJy2YnJ5LT9/9tPEaVmlge6SEKDrJKq/Kp095
         LUHrm3vRacst7YQRSd4WbhxJxCrvuRECNqC0Mq45G8cYccbtqc/wCGNoMVpKdDrOAZVm
         Qs0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733233333; x=1733838133;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TPziSiz6FIPz1llFZL4/mtv70ocOZmo18hfdyDsh/VQ=;
        b=pm1kTatIrwDTzArKOkDxSGeHKfa59IhAtzBllguft5u17/5Yp5ochLWm8deUUWjV3Z
         /TY6O8GMi1JUjfwKgThvnwPgaH7Uc8q4GAOVFbb48BgD5+fTVFK36gV0X3v70wAHMV80
         rCs0GGMu8NRv97LpsXOB6btp0IeOu/D+BVnrnmq70dE/5WYqshUclRipxJ0tLs9KfVkI
         My9OZDITvg8+8YZ5CrwLwkjIFPLRdljpjH3hdk3e+m5AaW58Fc+OtOeKExVIe1oRKidk
         iE6KtmPx0Qa2pb/rpfSjrkt/ptbGd8W1DmxZyDPRlx6/hwuMYU+OJM9nh96iv/JXUdS7
         C9HA==
X-Forwarded-Encrypted: i=1; AJvYcCWI2TmsxI/U0bc2chzIRCjxS1VQr7TBoE/jaNjo4AZsvDAdBg0vasjwAnIBiqBrzozAPRurjRjTXkuH8Sm4OA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyo7xJy2xC7DqVY2glxAjxZW5owRHixlnp/cwdMLYBHDfEOY3tU
	rUywa0T3x0I5Py7U2fhPJwiSZxmX+Gz7FTeqMsNTAmGcxrSZjSRGLqVM8FNBxW8=
X-Gm-Gg: ASbGnctppOeviQz4q4A4mMHQHGxIhklb/E87QtlHDltm6TWmfmzbQpmluFLQABmdWtj
	w7nCOPZ1VDyMfAM+8bsD9IXF/HccpoKGynDQp8Jqa2t4k5G710HslH2IfchKGS/xBdoFXV1U2O+
	xYY8QhBjZnAv7uQMftXrtC3wzAdAa50BWF2IDQJbkw2AGjeN8qDchc0QcxyEI6gZhz6XYW3TqET
	s6ixbKleSiQoOAKy6g8hsgZMmldB1rsnA6tlYKxBFG5Lg==
X-Google-Smtp-Source: AGHT+IF3JxViCcZr46UetkoBs9MyylLeqwOA8mylprKsogFh27HKGMF5642pWucfOY8iKk1uqQ4f1w==
X-Received: by 2002:a05:6820:50c:b0:5ee:d89f:1d2c with SMTP id 006d021491bc7-5f25ad40e71mr1942008eaf.1.1733233333038;
        Tue, 03 Dec 2024 05:42:13 -0800 (PST)
Received: from [127.0.0.1] ([130.250.255.163])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5f21a4cd86bsm2782124eaf.29.2024.12.03.05.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2024 05:42:12 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: John Garry <john.g.garry@oracle.com>
Cc: haris.iqbal@ionos.com, jinpu.wang@ionos.com, colyli@suse.de, 
 kent.overstreet@linux.dev, agk@redhat.com, snitzer@kernel.org, 
 mpatocka@redhat.com, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, 
 dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org, hch@lst.de
In-Reply-To: <20241202111957.2311683-1-john.g.garry@oracle.com>
References: <20241202111957.2311683-1-john.g.garry@oracle.com>
Subject: Re: [PATCH 0/2] block: Delete bio_set_prio() and bio_prio()
Message-Id: <173323333147.59116.15700360793401292347.b4-ty@kernel.dk>
Date: Tue, 03 Dec 2024 06:42:11 -0700
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-86319


On Mon, 02 Dec 2024 11:19:55 +0000, John Garry wrote:
> Macros bio_set_prio() and bio_prio() do nothing special in terms of
> setting and getting the bio io prio member, so just delete them.
> 
> Prior to commit 43b62ce3ff0a, they would actually encode and decode the
> prio in the now-deleted bi_rw member.
> 
> John Garry (2):
>   block: Delete bio_prio()
>   block: Delete bio_set_prio()
> 
> [...]

Applied, thanks!

[1/2] block: Delete bio_prio()
      commit: 099d214fc7abc3fec0f38d10bec31ac7acce8d13
[2/2] block: Delete bio_set_prio()
      commit: 77cfdf838d8467d3ca44058caff7c1727080efb2

Best regards,
-- 
Jens Axboe




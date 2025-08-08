Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC7E2E36E2;
	Fri,  8 Aug 2025 05:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754629607; cv=none; b=F5p41QuLvyM6RSjgcnfiA3iUCZiCw6EwJs4avArp+mopUDz9US+ydyNuwVG+1dWifUwTf6oTbmMoZtURB4JM2MZu8sPqyAXxPB5+hhoydj4R/araIf/jc/4FTb0TbqLzeqS4dM6w/EHXY9Hp9YQWUsnrC99sKLrpQ9ytFyeAbsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754629607; c=relaxed/simple;
	bh=suTlc4sym3MBM4sSUhPV2lEgazAht8TISNbm4YjTQbc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=V7yqUXb/eIsZ+Hk39Lcf9Tm9DM+u3r8aUB+ldrXqrxdeYana/T2259AfS4J+/qI7cn18V8rr38k1r68Qvjx2Yirk66ALshLbZQP4H+T1hSFx8D6tvXITpt6h/ZuXU+iXjJrior8jU7Dqzaoy5ygnxjA4KzO9/cEv7VXJo39ELIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZGwXVSSU; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZGwXVSSU"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-33275f235ffso25075341fa.0;
        Thu, 07 Aug 2025 22:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754629604; x=1755234404; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=suTlc4sym3MBM4sSUhPV2lEgazAht8TISNbm4YjTQbc=;
        b=ZGwXVSSU2ZeWFojZKI/UNv2hndLxsnt8StYPSrMg1T75qQLv7KC2wKAHnYHxuigj2+
         xHYO3Fye6J4Yp9q7CiGh3PBS3C9/ueHwGHz2WCIENGrHlefYBV4mUec9DEJpgcqEmJu5
         25UACSzm7FaSZ2O1uhrgBkltQanzDjgNw4arJtztdFcAvF3htgNpwFKnOEJKwp6EaC49
         YF0TupJ3jIxE+/VzNuszpG+XgoDvutwLMNOBknttdcfPFXkmk9lWhEx4TzYoBwt1TLcv
         tlm/dsYz/Z93OFaP1E0TVqxbl7s9P/WeMWk1g4XYV8SjJUS+XLm1jRzeU+VJXFejQt2l
         YkyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754629604; x=1755234404;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=suTlc4sym3MBM4sSUhPV2lEgazAht8TISNbm4YjTQbc=;
        b=cn4bkmigoa3fEF2yb+NRhArkCsLHDUMwyM5fLrISx4rwEznuJW8En07j264oJePH8/
         V46yrBucUtZwEsn7wNWktrvRVilV+53Lut27+kRYgaLWAPW5l8nqVIDbIgh6AjA3wUoH
         V4VUkIq/MaSpS1t7aiXFrK8tTmIySZWzMuVJlQNYeAATvCF1/gjZWeSYPVLAegrxjdU/
         CmS4g8x8yi3mJ2B0VA9MvxwjjZaPzrrzIodZi3BobvshTlh3mVCO5NtvVX9GLZVyjXwF
         W+xC8iii6Cx9qF+FUj//XGrlC8aEfnUnbBz2mUgOY2nFqduscqge5cMC21VfVVHCsqaY
         DKlw==
X-Forwarded-Encrypted: i=1; AJvYcCUMGUacjd0CdSiWpAmB/C3DUHcKtbKxZHWZnruE1yUwkHdNmGTVf4PCkcY9Zj4+zPk0psbB3czOPfCmm2ZH@vger.kernel.org, AJvYcCWK/vGVqI4q+I4Xp3J6HK2b4nYCjX63itaRH54X1JPY99CUlwgOmuF7vKoHGbk2COnLUggtLzKVAc0Eu6A/Rw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7SVMfoOCFGRazPvaoaAWiNcr/SAVJiWd1hw8IuJpFqqMNDuNw
	D6tRoN55lVPD2kqJ5WpYltWVvVrLQZtZNBUu/+oenQbb+LLDDXt3NPpDXZG8dNcvVRcDdETNnyN
	5zg1q0B8OpPBPVtLS1yhcFODkpHsecXi3cMQYF5CIoQ==
X-Gm-Gg: ASbGncuOlvHHANcUAHbXy5iR1uDElKvTjY09ccYffimFkMsYVO2GQefh2HnRaW2/82X
	KK7D1oJdjvijv2EE+W21xd2PL2gixrLBOSaipNG6vP71ayoUEL05tuj+06qPXnrHWZmy60wCYvQ
	oaGuVRx53Pnafk5Ml6/dZZIpXp7Oz1s9CzyjQZ/8EyyQAf8SNMHJMZH9mGJ6bkziezXwTsam/0j
	4LSzc4=
X-Google-Smtp-Source: AGHT+IEyi97kyr5yrQuAHhluU2zRN3nY6mmZB0YSjcm6IZshIwPDV9iTEiqw9cDcrERMXEvqeXqD0ktBb2ohRaWvPnM=
X-Received: by 2002:a2e:b88c:0:b0:332:1d26:b20c with SMTP id
 38308e7fff4ca-333a2539a85mr3368591fa.4.1754629604023; Thu, 07 Aug 2025
 22:06:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Alex Galvin <alex.v.galvin@gmail.com>
Date: Fri, 8 Aug 2025 01:06:32 -0400
X-Gm-Features: Ac12FXzehAvwEj5d_2kpDBXoG4WlzF9REUVsSx3X8ZJPRidjHFbi4uNda_-C31U
Message-ID: <CAOaPw=i_4s_OPuSqZiKqWNXq19H3K6U24o9fn_m71CT+a35DOQ@mail.gmail.com>
Subject: Bcachefs plans for the future
To: torvalds@linux-foundation.org
Cc: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Linus,

You've stated that you and Kent Overstreet will "be parting ways" in
this kernel release. I understand your words to mean that you will not
be accepting PRs from him starting in this release cycle, with the ban
continuing indefinitely into the future. Please correct me if I am
wrong.

Could you clarify what you will be doing with the code that is
currently in mainline? If it is not removed, would you still merge
bcachefs code that was sent to the mailing list by someone else? Would
you accept that code even if it was written by Kent, so long as
someone else made the pull request?

Thanks,
Alex

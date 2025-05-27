Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1F925A627;
	Tue, 27 May 2025 17:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367570; cv=none; b=TmFct8J0lmm0KD9cv48L2NI87Lr1rVGkIMp9eIzELVX/q9/F6k1iRESC0OxsTALNVoTk83p1Yx0B2xmDAUcLse+LM8lWXEJNhzTn5IzsKnkdWDbZNc03oWWBYqZL2GqiF6oNjONmBKB/ZJgat0CRvWB/U5ZpJJOXdeFfQ2lhnII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367570; c=relaxed/simple;
	bh=EYOOSZHmScBYxroLZyX5hgkJJ4393kMj/n1uCQ7iaAE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sqoUoC1JY9PdtGLrJE7FEiy7o6nwh8V+Eqnljk/6aLChB9p7sW3ZwlXpY4NtMP0NNkc5Ct/e9mEG4zgFmyQjj9RZ3nAxF08VxTYSwrp96H2v1wAq5bKVuLY5WxdiERkixAZcBmIR/tTClhqALGLKns08Yfe7ztDbAx++rkmCugk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j2Z9IQoJ; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j2Z9IQoJ"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b1fd59851baso1831090a12.0;
        Tue, 27 May 2025 10:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748367568; x=1748972368; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EYOOSZHmScBYxroLZyX5hgkJJ4393kMj/n1uCQ7iaAE=;
        b=j2Z9IQoJh1/Igqfgo7TT4JKFdO8N68zv49OZ5Om0i25Y3addQyZzO9BVlgDEVsjayz
         eGUQngAb16UN07KjyKxVDwrhuQxoLPGNNeX4Daso6lhi14hpha69/Kh9jqJK5/I6ZFpA
         356S9YmmH+l8KVGwtGUTp607J838Ra+ws4mEfzW+OmzL/biJyPsGCdJ3nOsarJe/hkVF
         zrk+FHx5AMf+YNtRQaGflK9ElYwfELMerkwT0RrD6OtY2T8EApt/w7eqmSBZEa89Ec6r
         9oUY8LyhobjyYvLnmg1bmrE6CiX6INC7xwGAJKMcxNKXzrjIHB3rjcLDcBocxi5VQ1NS
         ZuFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748367568; x=1748972368;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EYOOSZHmScBYxroLZyX5hgkJJ4393kMj/n1uCQ7iaAE=;
        b=Lgv88HCwzo9exNzy7rAmBd2eCuJbGodsil0GayM2RxU9OrG+cOqpOgX0EEKVfR491B
         tvuhhATJPuWnqbH/eZBoZZPhf4r5YbZHlKZUb7mVrwqNX5x67MvCdjr7Xzd6tZEk2SAU
         wsohKvhAjww+htc7eeCZUd1eUdD3SJncNi39a4VC3KNtkZy+sjo2fv3LaNNw+TJfcRkC
         0QNCX0YTGJ2n2I0dhylXD0EAd/wCwuoC5IFRqP2HZLNV7nhZXrX3hoEQbydhBbEEYanv
         +7J1yGG7xQoHMVeDg6cbDya9T3Lc81vXoaXyPBd7oHhTBIBqEcZk7V4SzDFxSeyNbCEG
         6pdA==
X-Forwarded-Encrypted: i=1; AJvYcCWRkr5maaW4mYJkpMr5fCj1QFOJbQMPLvsmDeKS1eU56/Xw1eOoppPvJMGkTOYOEqcIoG9XEhQDX90m3Ps=@vger.kernel.org
X-Gm-Message-State: AOJu0YytCp8/kq57UYCFaumZtkkg7tl0IDhazPIhPgqFH1iLYgwFPv6U
	kYQmZa98+5G5O7dAEgXJbyB6MYwnhcyKoF/qtZIUgzaPKJjmgggpW6sXcXV1FX//C67lg8M57ow
	cQbm7SJasHygzPdAVDnaI1fK0UsODfRfGmMcuI3s=
X-Gm-Gg: ASbGncsNij/hvSk6roTvaHtNt1pHjO6MSJx9qBsw4UBo5jV7ZS4FHmJB5K8rTQYe1sv
	lK9YA118CMftsJXRztR0IIxI02JxwHsQEWCGfgF+Ga59mDhyHjUs1GVhaRdhIm1qCkVPm+BeHtb
	ZG7PWK4CfrtVatAq/UTm020ywPa+0z4jB6aQ==
X-Google-Smtp-Source: AGHT+IGsD9OEtRNbZXsR3KaaCuXRpPRdDOCA9O1CN8Y5Itz5Ik3JkiACaDxLYDLhu3OKDmKe/EEPmaT/zhGc69A/fKQ=
X-Received: by 2002:a17:90b:1d12:b0:30a:b93e:381b with SMTP id
 98e67ed59e1d1-31111a51e1fmr20529925a91.35.1748367567935; Tue, 27 May 2025
 10:39:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250527173116.368912-2-bharadwaj.raju777@gmail.com>
In-Reply-To: <20250527173116.368912-2-bharadwaj.raju777@gmail.com>
From: Bharadwaj Raju <bharadwaj.raju777@gmail.com>
Date: Tue, 27 May 2025 23:09:00 +0530
X-Gm-Features: AX0GCFt6U1sh2tAr-8WigeV2EAy1B61xkhRWpwGKCdbr6iSiyNZkk6ZHSdN2EPs
Message-ID: <CAPZ5DTE1z=PPm+v718ZfgYg0oJkEKHJ-pxrSjSGTmxQVqzaP7A@mail.gmail.com>
Subject: Re: [PATCH bcachefs-testing] bcachefs: fix goto jumping over guard initializers
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org, shuah@kernel.org, 
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Now I'm actually not sure this is the best solution -- the comments in
include/linux/cleanup.h say that gotos and cleanup helpers should never be
mixed in the same function in the first place. So ideally we should not use
these guard helpers until we develop helpers for everything that
we want to clean up using gotos, like printbuf_exit, bch2_trans_put,
and so on, and then switch over everything at once.

Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88691768FD;
	Thu,  3 Oct 2024 19:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727982719; cv=none; b=J9CqCazjSJKeqthWdPqzI+8VFbC0UVOnlBuf8jhCJNpx5JDRFU2nhjxOD1x1Rqa4ljMoRvSbYH8E6WapDkAdk9a8wBbMg/Hrky3pUx1qC6hJRZV5z7b+Thjgg/c1N74Tv4vLywcUHvOhP7jLuqpc+Ue7W1For5/5nt2erOYQw9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727982719; c=relaxed/simple;
	bh=Och2G1g7ZwExIWRCohJryiNq1dseTovl7Jf8gf4N6DA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ixt19/8PXixFiM4Qxz+5PbIJ0urWWQ0XJznH3NfHSU8tYi2LUbsiJrDuiUu2rH82tqd5ne3hIufcWBskUl9xxIq4BvvSd9UgRFDmosyDkVEkuqqce3pi4oB9DHkc8nV7MbVKh2YeNXlTHNwR6KSjVNO4lbSkdPCCMFqrta6y5FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UKiI+B3F; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UKiI+B3F"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-7e6d04f74faso1159352a12.1;
        Thu, 03 Oct 2024 12:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727982718; x=1728587518; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Och2G1g7ZwExIWRCohJryiNq1dseTovl7Jf8gf4N6DA=;
        b=UKiI+B3FSQ6bVKvnyowce6q7bfZnBad1bDACUo3EoESKaxQI9bnwN6no/TqMRj4z5x
         9fddeP0BYophsTd/DVDcFsHHIirRFUHuL19NtD/qopqCkgKZGHWYMQ52lX2GHR7q/X80
         4LUGY6sp7HjOI4BVaGazwaVkhsWxZ30AZ25SDRVrfHuaVyWGlgsuoVhAm7x8q2Ethn0a
         oLCvyCHS3lZwe7suVy501r98KcOD8aLokLqkpjZ7rkirDwNn28JQz+vBHPcR4LmZxeKg
         ig/8RH0oGTtXEEm424mXUZtgwccoMYwxbIrzH8nPaCti55aUelE5DOP9U8T4lBrShR2L
         EVDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727982718; x=1728587518;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Och2G1g7ZwExIWRCohJryiNq1dseTovl7Jf8gf4N6DA=;
        b=ktLzJVqo9kFm9fkADncfludddHC/AMU21KDz6vgQbNep+RiRCuZ+WTOKx/SMO7u+xx
         xKhcsoGUuTzmvcnN08p/M1ev1BbTfSrszNcXTr+Sq7rQNlhS5LV+lHIm/NLAROFthX9t
         QdZ+noSh+yDA4YejV2mVRTRNBmWHF0U2WDHbsVDyux3ojsVP382+YbavkV6DTA0tKAMv
         /Epm3xGqOWbrnjXGKqIll+8ApR+2CTrf1OvnC9mwDHmxEs2nrVH00FM2eMGX2KotLETd
         4iqYfj3B/bdanBj2Q0PAXN9J9dKUw72OhejFeApZ0mUFiAP4rhEeMnx51GotSdZReoAF
         YlyA==
X-Forwarded-Encrypted: i=1; AJvYcCVhi3Lk1JHXYv6s6+HasvR7NNnR/6yJUDgvPJVzYx6nM1n7mRg7hTYKXFPnz2Eb65A9sDmrfzkxUI0AW/q/@vger.kernel.org, AJvYcCXCepzD2J22dgZwr6uskRFmlYzTtwd+lZoPdKNFaNStjjnXvW8zsvWQM/hKdRTaWjZjkmlUcB8c+UQhEGEtfg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0/4wyMwynfYuDwVLtmw5u9zjpvQM0z8nce5aV5lkObLSQytny
	+JmhPddki0yF3dN8rUO027f/W3awuvU8uQWOrbHJcHvWohcWPCVz
X-Google-Smtp-Source: AGHT+IGdUbpi1qv7PstJfDj/UuF+/Ng56Lk4A9KPU88v+YVLnaqR6otSjvQ1ZffBnQ9+y8hfX9pf1g==
X-Received: by 2002:a05:6a21:718b:b0:1d4:f661:8937 with SMTP id adf61e73a8af0-1d6d3a3d91fmr5173760637.4.1727982717673;
        Thu, 03 Oct 2024 12:11:57 -0700 (PDT)
Received: from archlinux.. ([2405:201:e00c:517f:5e87:9cff:fe63:6000])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-71dd9e073d2sm1716333b3a.198.2024.10.03.12.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2024 12:11:57 -0700 (PDT)
From: Mohammed Anees <pvmohammedanees2003@gmail.com>
To: pvmohammedanees2003@gmail.com
Cc: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+37186860aa7812b331d5@syzkaller.appspotmail.com
Subject: Re: [PATCH v3] bcachefs: Fix NULL pointer dereference in bch2_opt_to_text
Date: Fri,  4 Oct 2024 00:41:41 +0530
Message-ID: <20241003191141.17694-1-pvmohammedanees2003@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240922004307.8020-1-pvmohammedanees2003@gmail.com>
References: <20240922004307.8020-1-pvmohammedanees2003@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi hope you are well. I am following up on this patch, I would appreciate any feedback
or comments on the patch when you have the time.

Thanks!

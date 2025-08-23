Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com [209.85.210.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E624517BB35;
	Sat, 23 Aug 2025 11:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755948940; cv=none; b=mDX70qWEZGiYKWA5G2DbT/mWxMh3Ts2TB9+peAC1i05Cm4yP5lTF9NzJIDkNdrCMdJe7Lp6QU1iOwZNxhAAwwCtg1lJ5i72YQbohcwckwmDE0mDg5Lpj76RdlYw7LfC7osGdb6IPk5rcHYCtfnFlf7bT/eaTFifjHVTqeIW0Vkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755948940; c=relaxed/simple;
	bh=v1qmiSYz1D35zpM5ZtRNW854M3jN/PJdWISAq2j1gk4=;
	h=Message-ID:Date:MIME-Version:Subject:References:To:From:
	 In-Reply-To:Content-Type; b=smOHZjC0zlV8S4jIMqm1AuNX4bkjqEAchxMA8McJq5Uv1YMvR2ntKDePHaSf52nbBtVEzm+FBCZwtD1PJLllywurTaeF9ckmt/oh2RDZ7DiYRPJBAz+Y6yxwmAQdmwt1+9wqDs7VEDLoT7/uqLDN8fgW19iRYfrZYsLtuuyUByY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IN0w2KOa; arc=none smtp.client-ip=209.85.210.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IN0w2KOa"
Received: by mail-pf1-f195.google.com with SMTP id d2e1a72fcca58-76e2e629fc4so3032669b3a.0;
        Sat, 23 Aug 2025 04:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755948938; x=1756553738; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:to:content-language
         :references:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7UPus+PKpldp2Cckere8GWo9i5py7oZG63TnhAaSZfg=;
        b=IN0w2KOawNllN/YflzUDwv/Hm9O2fM8yoXhKS7Vu6B66E9/dN33dXegBetEYHYJBwn
         n+V+tHMOybOOQcF3T3uygjxx5H9mS+VtBujn7rvRtUUk5x89VSbvkOvINcfiNHXHy0gI
         barklDXF0J2P/rFSyAImzXUyQOrTZ2RvAdsB5V3o2MNymArnRZwbJsqmCibKgqNUTKOU
         kjE6EZCfhRL2hjvusKaLsGVkxjbxQTmRLDQ0rM8xbYeyKW9GaI9FFEzZiK21ziiwmJ4R
         KcQfzsBY+rTY+0PfPRoRCZNybuWhic8TzSLZh6n9jOImeCNj44zcbR1KQPYnzEHJGMoI
         wG+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755948938; x=1756553738;
        h=content-transfer-encoding:in-reply-to:from:to:content-language
         :references:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7UPus+PKpldp2Cckere8GWo9i5py7oZG63TnhAaSZfg=;
        b=VCxdbjQvJ2zonfIuzFuGCu/tbK076uOa/exSTe9ZBNp1NW96NbSK8cWcawtK07YPEb
         k6/3dUApjeMUvQ8VpOZYBNCPwQImlrOJQgNS4yrtXp+juzSV4+RUjdXH95ji+RlZpCJs
         KcWN5QTevnFpIUHc1kLqvMj2wbF3AklkVFtEC88qQ2yXfHDDn2jq9q0nh6MxojMJEcLh
         0b8iA/Ivl2on3gt0JPStqUAGfHFuV2NcFS/KUN+6DzcnvYDjl7DL+8QVSEaZL2S/6FM4
         f0jtwH1gsoZSq6eU3YPFLDQoNkmKJtHAVRjGB/e/0JUojGYmwxh4C737VkcM+7LiZe8Z
         q3XA==
X-Forwarded-Encrypted: i=1; AJvYcCVJ2WnwnebOSnKM65K/01MrTybVyRDYIZWi6E/FcgyshT+/+NkLiWCTBlPseAWzQl76ZDjgL8iajrvSl18nFw==@vger.kernel.org, AJvYcCWrtiSn3hRkhdYeBQwujkxWNg1P9tInhhgfW8gGj/u6st6w6QSuSUjEX7kRrZQ8H/Se3ZhK/+WVd9b4@vger.kernel.org, AJvYcCXh6tAej3i5V1AJLiJgemjo7TaZXGxSkxfzXxO3YNmh847f8rLESSqQH5Qd5UakLTK53RHoo8tkBN2B85MC@vger.kernel.org
X-Gm-Message-State: AOJu0YyO4HQaWXSIseZQvXVx4RvB1HmhZvWR7HrFEVItICqNiToebIyX
	zWD6ueBk15Qdgr6SCzP87Yvy0aS9/qZwAhQht2RUHE8aV2XvjEBGuHes/YIYKYBL
X-Gm-Gg: ASbGncsUyx7R51+h+VYMv3XW5vmam/BO8F24jo0AsV0HiF4dnskEWEYu+r9G9+2ylso
	MTKyyHLjNHDOvfROnqITFwe0roIue8LIeVAy9MEZ+1TZu5UedYXtqLHebeOIEDn0GQhWA58oIDK
	wC/f8ZtEeSUgvR+FZ453RwOl+Zo3qChJypUpXuLY3yXYEpp0zkWxc0tXF1QP1c/Cn5y/rZANRuH
	CwgxkDZxGFXTfraCZHdYtK/f+hPi+iSIGdeW5XYpmuTTWOqklR1Jyp01sXxY0HjX4EQAu5IsKE8
	5EtYShk3N5TgJ8QmuPYwiQ4mENbeWv/4gnKspkgCviVI3aVj9tQRq54MQbArEzDgcKibE4EXTj0
	PKpnx0DcTN85WQ2iXk0FRDqR79rRurWG4VytKHAXTes42YyplY2cG8k5kxy0blndfwKzH1qqBBh
	GdPVIKDKOm1kPlqc2WXcN51CwUEKKcwaSaX/bBuHtd
X-Google-Smtp-Source: AGHT+IFuF7eWEl14L3vPcS5m9Rt+xpa6jEw156snDGDEmNgdJOeyzO8r8tYKkvkGiO7S93/tG22Liw==
X-Received: by 2002:a05:6a00:848:b0:770:4b1c:8155 with SMTP id d2e1a72fcca58-7704b1c8453mr989887b3a.31.1755948938096;
        Sat, 23 Aug 2025 04:35:38 -0700 (PDT)
Received: from ?IPV6:2401:4900:1c27:426:f844:c020:2374:f736? ([2401:4900:1c27:426:f844:c020:2374:f736])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7703ffed02bsm2311508b3a.24.2025.08.23.04.35.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Aug 2025 04:35:37 -0700 (PDT)
Message-ID: <c9cbd06a-9564-452b-bf05-8bfa83b81aa2@gmail.com>
Date: Sat, 23 Aug 2025 17:05:33 +0530
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH v2] docs: bcachefs: fix typo in idle_work documentation
References: <20250822223416.23345-1-chandna.linuxkernel@gmail.com>
Content-Language: en-US
To: kent.overstreet@linux.dev, corbet@lwn.net, rdunlap@infradead.org,
 linux-bcachefs@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
From: Sahil <chandna.linuxkernel@gmail.com>
In-Reply-To: <20250822223416.23345-1-chandna.linuxkernel@gmail.com>
X-Forwarded-Message-Id: <20250822223416.23345-1-chandna.linuxkernel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Fix minor spelling mistake in idle_work:

- heirarchy -> hierarchy

Changes in v2:
- Dropped cgroup, idle changes (already being fixed)
- Dropped xfs changes (already fixed)
- Only keep bcachefs doc fix

Link: 
https://lore.kernel.org/linux-doc/23de3jgp44vih5g6hjgc2ji6momi5t3w7rfkm5mgtajicbbg7a@7r5hgt5e7eir/
Based on v6.17-rc2.

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Sahil Chandna <chandna.linuxkernel@gmail.com>
---
Documentation/filesystems/bcachefs/future/idle_work.rst | 6 +++---
1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/bcachefs/future/idle_work.rst 
b/Documentation/filesystems/bcachefs/future/idle_work.rst
index 59a332509dcd..f1202113dde0 100644
--- a/Documentation/filesystems/bcachefs/future/idle_work.rst
+++ b/Documentation/filesystems/bcachefs/future/idle_work.rst
@@ -11,10 +11,10 @@ idle" so the system can go to sleep. We don't want 
to be dribbling out
background work while the system should be idle.
The complicating factor is that there are a number of background tasks, 
which
-form a heirarchy (or a digraph, depending on how you divide it up) - one
+form a hierarchy (or a digraph, depending on how you divide it up) - one
background task may generate work for another.
-Thus proper idle detection needs to model this heirarchy.
+Thus proper idle detection needs to model this hierarchy.
- Foreground writes
- Page cache writeback
@@ -51,7 +51,7 @@ IDLE REGIME
When the system becomes idle, we should start flushing our pending work
quicker so the system can go to sleep.
-Note that the definition of "idle" depends on where in the heirarchy a task
+Note that the definition of "idle" depends on where in the hierarchy a task
is - a task should start flushing work more quickly when the task above 
it has
stopped generating new work.

-- 
2.34.1


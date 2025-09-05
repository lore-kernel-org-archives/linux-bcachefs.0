Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0344E219302
	for <linux-bcachefs@vger.kernel.org>; Fri,  5 Sep 2025 08:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757062596; cv=none; b=SuK2e+LGT7F2zT0FIiy7b3oAADC/+t443M16rWzhfn5uXVNUc/pZHyT7odwhofBZonsa9r2a5wCYFmh0I/al3IcYiUy+AcgVLYWt3oXJxQaaVYyWfh/FWMRBsqtAn3uH9wE4u/kOxHjHCeyJdgQQx6KuMuMXGbv6Ic8v5GuHX4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757062596; c=relaxed/simple;
	bh=WLkgUTcXTLcT4XNAHaelQ6EeG3oPIJHi2zqV6+Na450=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hYNIRMetGvdYYWXk5Korzmhc9D0HnodNuMjOKglxkdTLWWVbW8LugI6FEBgQY0GvhKqZNwLH1Kp5Rwzq6EfozUNci5BWIb/FZWwudygSjGy4ydy8oaBm6AuTpLZ97V1LR9TECwuvzChvQPyY3zneuQiP8v83IzG1WX84H7pPF0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QPSvd0mM; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QPSvd0mM"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3da9ad0c1f4so1274629f8f.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 05 Sep 2025 01:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757062593; x=1757667393; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vW3lsZcaZMrX7K+9f/cocV4Li50JxVqGTdUvw9TK1b4=;
        b=QPSvd0mMRCleHNvGvoHEt0rWM3lMKlyVqGyJVoQuUJxzBfImrQGjoseeY3YdaZMODp
         5Z+tzsrq2u6Y+jOAohjYz1MPZyZxoMgsR0hsmQg5JwLsXH8d4bcTNIPaSz7mxjqa3cn6
         0CkTtnlTkrmoV4ay3QDbKV7jNwZGhvUaenlX7O6j/Blj26pzm/bhbFD/ZyHKvqL2R4yw
         /yccp1W7+myKTp5Ql0+qpq2CU76R1+kdd4ih2awAfieHjF0H+d4CG5e6nowOjUo/wyda
         HGwNFj8bD9zNpw7qFuAlRNAAA7FcumMNV8Qc97Dr+2UX5yQJVbAbiYkV3UuY4vb8ld2B
         nRVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757062593; x=1757667393;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vW3lsZcaZMrX7K+9f/cocV4Li50JxVqGTdUvw9TK1b4=;
        b=ZIur3yx2UNMSY4a4Pl2ZQVtOniiIfa/eVQFXkRjMqvW1/Z90aQ0Lu0dbaWtVZyTALE
         iS4GR5+WyJjnrzAn2IeXm7rBsPd4ljY0JGq6R5nmdqbGBY35wqYRq/4m2uCUNa9r1a0L
         SAeq+vpMr8i5/BkrarZwphSgnyXchqaJ7Kd9GS69mW5VjwauyWCgEpIfGtPmr9ZHCtLk
         VMi7GiKjT0HeUy6TJf81eFZA+EGDSFgfAL1gZCS87hLwYwlp1YFP3gaWudhfDxgRrGvs
         QmeDC+HzAEmJBYFs9KLuzfJLL1GL0CkLbNnnatbDRg6+ltPonVkhOPMzZUNqL+36lkR8
         A4VA==
X-Forwarded-Encrypted: i=1; AJvYcCVk6aeuwjVw/CrTv52mnQWfj9PfshRqPdBIMnmeQ17IhZEqsHtgo2KMbza+JRhJYxytXs4VO6RBFjklaB9PGA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxR8vtjIy1vUd1yYqQFCZwbAC8mdUtzFwMec8yo+eqrWl0bO9An
	jKZOLFucRadNHkgxVhLhTlqEjLTLBg8p+d8ArC2f7NF8xbzRSsZfj6S8zoP35VRtDds=
X-Gm-Gg: ASbGncuyOTy+UFENHDq306qkT2c2Nvy3sKHS8b4sKFE5Jwi8d6Zf7iqQyVZP19kSbMG
	tL6nUUQg1JfH3lthT5b2YWAd61NBlLfMrDPN5e9v7cikkNJL2O3ui7YOS1OGhy2Nq5HVLVBg33Z
	W87O7M7RhZdDv2EIZQ/tYD9Vmx/HojDY+tA0Up9+bJ7e2gSUeddZZ9A4OaCzyajnkwudL4pNeFV
	aKFD5D6/TbFDvu0VuOV9XFLp0Iaqw6hRW0AOIz+1T+R/naW9b63jhFX2Fm1ip0PtWz5WZg2VnOr
	RjgyaKj6OxgRRbGA/l1QmHfYjHVyu24LO1PZX/W2vM8HoaIeOc+hhT5zOQ6U2jL5z/0+EG5oSEA
	dCK/gyUNoe3MM2cA93ulAiXMbJdmFnYc1ciCL52T5yJJC628=
X-Google-Smtp-Source: AGHT+IEcKfL+ORDw3exyEHP43O0raLwQamTpbLFiwqrjH6BTttBVcvfN+hVUhcNkyeAKD1R/N4uwkw==
X-Received: by 2002:a05:6000:2d82:b0:3d7:38a7:35dc with SMTP id ffacd0b85a97d-3d738a739a7mr10063370f8f.12.1757062593121;
        Fri, 05 Sep 2025 01:56:33 -0700 (PDT)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3da13041bcasm14617492f8f.35.2025.09.05.01.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 01:56:32 -0700 (PDT)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-bcachefs@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 0/1] closures: replace wq users and add WQ_PERCPU to alloc_workqueue() users
Date: Fri,  5 Sep 2025 10:56:24 +0200
Message-ID: <20250905085625.97367-1-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi!

Below is a summary of a discussion about the Workqueue API and cpu isolation
considerations. Details and more information are available here:

        "workqueue: Always use wq_select_unbound_cpu() for WORK_CPU_UNBOUND."
        https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/

=== Current situation: problems ===

Let's consider a nohz_full system with isolated CPUs: wq_unbound_cpumask is
set to the housekeeping CPUs, for !WQ_UNBOUND the local CPU is selected.

This leads to different scenarios if a work item is scheduled on an isolated
CPU where "delay" value is 0 or greater then 0:
        schedule_delayed_work(, 0);

This will be handled by __queue_work() that will queue the work item on the
current local (isolated) CPU, while:

        schedule_delayed_work(, 1);

Will move the timer on an housekeeping CPU, and schedule the work there.

Currently if a user enqueue a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.

This lack of consistentcy cannot be addressed without refactoring the API.

=== Plan and future plans ===

This patchset is the first stone on a refactoring needed in order to
address the points aforementioned; it will have a positive impact also
on the cpu isolation, in the long term, moving away percpu workqueue in
favor to an unbound model.

These are the main steps:
1)  API refactoring (that this patch is introducing)
    -   Make more clear and uniform the system wq names, both per-cpu and
        unbound. This to avoid any possible confusion on what should be
        used.

    -   Introduction of WQ_PERCPU: this flag is the complement of WQ_UNBOUND,
        introduced in this patchset and used on all the callers that are not
        currently using WQ_UNBOUND.

        WQ_UNBOUND will be removed in a future release cycle.

        Most users don't need to be per-cpu, because they don't have
        locality requirements, because of that, a next future step will be
        make "unbound" the default behavior.

2)  Check who really needs to be per-cpu
    -   Remove the WQ_PERCPU flag when is not strictly required.

3)  Add a new API (prefer local cpu)
    -   There are users that don't require a local execution, like mentioned
        above; despite that, local execution yeld to performance gain.

        This new API will prefer the local execution, without requiring it.

=== Introduced Changes by this series ===

1) [P 1] Replace use of system_wq

        system_wq is a per-CPU workqueue, but his name is not clear.

        Because of that, system_wq has been renamed in system_percpu_wq.


=== For Maintainers ===

There are prerequisites for this series, already merged in the master branch.
The commits are:

128ea9f6ccfb6960293ae4212f4f97165e42222d ("workqueue: Add system_percpu_wq and
system_dfl_wq")

930c2ea566aff59e962c50b2421d5fcc3b98b8be ("workqueue: Add new WQ_PERCPU flag")


Thanks!

Marco Crivellari (1):
  closure: replace use of system_wq with system_percpu_wq

 include/linux/closure.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.51.0


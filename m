Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35D47DA90
	for <linux-bcachefs@vger.kernel.org>; Fri, 16 Aug 2024 18:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723832582; cv=none; b=Hojtqc/e9hzM5F6MiWTtddxDP1EnLF3yg3L8aRLy3QhTuM0WOtaIy8k94Lsa/9nlI7vykGlyyXd9zlMgIeYw6wgIHCzsoakrTTEsw4dnbLRj1zg1Ucs7fIdq30scF4lGC1XLDpWonKoDyh92D6PiPQhC7XIHdPzkEcvlnDP5muU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723832582; c=relaxed/simple;
	bh=C/KPVQOdL61r1aj+fFYyQJ8nYW6G4L9oj+F7eqj0zxE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WIwc0EpHY+nGcdVuwQLBmi1DF98sK4jk+K6n4/VjeovLXq23VliEFuDyoBJkQwSEXzII3yYYDXUo6i/1HWRNN5f56m8V5Huo0aCYcXmgdPdk15hml2jlDV/zXRn6toRjWgZ6vhsI6jx9jiVTMhwltFtLd42njVS+4fypTtz+wn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CyiR2xY0; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CyiR2xY0"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6af8f7a30dbso37108247b3.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 16 Aug 2024 11:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723832579; x=1724437379; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Da+yOGUnAi9BrtxeKlOOzLVm+rCdCeLa2u69ZA1xPsY=;
        b=CyiR2xY0EqnCnwW5KUW0XZybvLPrnwZhEQH2T8zpbM7G6dOFUC92b0Jkj34jFfgJdI
         shYO1g0lX15CFBxLsw8nduXNJhHJDSEvuE8/fU/L7SZWPZyzDjo3Z+ZIf4YtL2tXkbl+
         eg9halxd/w28aSUXWxtXdXMG61yHN/ltToZ8//GQ8qDZBQ8qJsZaszW0dSSzdbFtvGgi
         gAAEsL2tQowcv1uxVbLPtNaBJEl9imscdeaUdzLH1yvOGeBjF5O+2haPHNxwD+PTi8ek
         7Immfc4GWmnzClq1y2mT2WSHYTpZSOu7+yPswSYz1t7O+Mj1QR+1Nn4CqJbgFx7E5IzU
         vrbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723832579; x=1724437379;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Da+yOGUnAi9BrtxeKlOOzLVm+rCdCeLa2u69ZA1xPsY=;
        b=TswdYSG79+0D64Emu4KPhhPz1CKCdk6+LnDg2FWYdqitXbBsyIVTGUFgQi5rAKigbm
         tKj4MoIeu3p4bHwGI+r0BtxI0TUFv/o+b2phoacTK29ELVzEOcW7QWsLL+yMNjDownhd
         z4Myt0zmDBjImLHBuc1nwfJDN5a9wROE9DkZR2yYwtZAM7YIjheuzYLFhDkc8sdMUa7A
         Wmjx4eH3r/aw2mWX+EdIKGAMI1TiMAwBaxKS4DXDToP2DrWCoUAHUb7ybGLlviib6bQ9
         DAp3U/uCe9bSlQbcS3XO2rsUVi+a3IHLuR+Sw/NTJIaBGVl1wM29bdi9xnxtUjPG8yFL
         jsXg==
X-Forwarded-Encrypted: i=1; AJvYcCXtZ++ID86alFVyXvNjJEMEjz5ED15w9kjPI8fYJKLXrcllrplGKNh+MEPn/32aNMXm7woo/NqvZMKUTt1KrjQqHaASoW8T7qy4yrAWrcM=
X-Gm-Message-State: AOJu0Yz/8AXu8FMv09PLrWYTMtZiScyJQsRvw4los0sgyTYxBB1SR0kW
	HeT0UJYMCTDTWJouhrgkTVJyqicNgPYfKY8sQ2ZS22lxy8qjkPipT/gqmU8FWD3HKPRD+6QUCBA
	8XQ==
X-Google-Smtp-Source: AGHT+IFfcTETiulkEGd1KSTGEzd2S0thNDH+lgRaKyP+72dCCah4oHM6tDo0fs41jUmb4XdaXCTSKTwY22o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:68ca:0:b0:e03:3cfa:1aa7 with SMTP id
 3f1490d57ef6-e1180e4a917mr5430276.1.1723832579587; Fri, 16 Aug 2024 11:22:59
 -0700 (PDT)
Date: Fri, 16 Aug 2024 11:22:58 -0700
In-Reply-To: <000000000000fbce8506178da1e8@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <000000000000fbce8506178da1e8@google.com>
Message-ID: <Zr-ZAsFVFiQuys7K@google.com>
Subject: Re: [syzbot] [bcachefs?] WARNING in cleanup_srcu_struct (4)
From: Sean Christopherson <seanjc@google.com>
To: syzbot <syzbot+6cf577c8ed4e23fe436b@syzkaller.appspotmail.com>
Cc: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="us-ascii"

On Fri, May 03, 2024, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    f03359bca01b Merge tag 'for-6.9-rc6-tag' of git://git.kern..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=14004498980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3310e643b6ef5d69
> dashboard link: https://syzkaller.appspot.com/bug?extid=6cf577c8ed4e23fe436b
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/1b4deeb2639b/disk-f03359bc.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/f3c3d98db8ef/vmlinux-f03359bc.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/6f79ee1ae20f/bzImage-f03359bc.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+6cf577c8ed4e23fe436b@syzkaller.appspotmail.com

See https://lore.kernel.org/all/Zr-Ydj8FBpiqmY_c@google.com for an explanation.

#syz invalid

Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF7B56757
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 May 2024 05:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715317686; cv=none; b=LwwE1f0A7Hq/WzP+Bv4/AxSw3Aazsb54HktYEzaw76ZzeMxVp8k9nP9gb3pQ8lyAlfVrq0+MiqUCdxHEtfgXUkE12ypIR7ufXnmlUHR+0yTn5gTOTBxWrT+XMRUebiBnbNpxkirwjeFYSQm9NU/n1nnggd3hmDXvfluyQDjAnJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715317686; c=relaxed/simple;
	bh=Pqy5lmmcw0oAX8mFgZ9RrdJ5pDBFdd8DQ9gUz5hvWO0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=D1mmP1zjFrRW5RlU/0Ix2U3j663sswJMFsPxGK8z9ABlwzzBSMwIvhWmZY7JripkgZOFKRQuLLRb/KHleYxYBB/o5gv4xSPTyRVywAJ6B45G+owo5f3XRwS8hgCLiQL3rVd1+0F2FVilHbB4IVj79tD6P1Fi6iKxKZLRSqicgsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7e182885d98so181079139f.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 09 May 2024 22:08:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715317684; x=1715922484;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AEYzaVFxClHnzclCpBQe8wBmRudx65WCcAHd23Nvkgw=;
        b=FBlWWVQ6x9fm1g3otjs9AteE9tCECp7+Jb7Y8WBYt6+H3B/bMNzh2LaM0J4SMa0MUj
         uH+7CycPzGlNR4WoC9HDAhRDRg0eJCYEqPMKMJiuhOG/iO3rzHd3jR3qPj9S1Y2IcIuc
         zfZq/x2KhscNX3XMaHppysRan0F3ZuKrrSjOD1BKlvrc0TU2kQiKe/2x0ay7APM0GO3L
         RSKKSubSalz9aRTTF31oXRj4gpcvHSfn/gIygSJ15iQykCuUGKAQKturHpkRHy33fHCe
         /jFA7z9U4dcwdcRKE/K7cH/BEBAzgniZaVOgJeRHISEdxYgsH4H9d+5YYFVw6SvhQppo
         HGPw==
X-Forwarded-Encrypted: i=1; AJvYcCXBS9mFDPciWwBzTvy8OGk6qLbmdKXatWMlnwy+19mzHvlqlbFV+0Y2gzBjk23nQXLfRedvzq26RuQCdqrhnu88V2CcQkGLkehdnJMMuvU=
X-Gm-Message-State: AOJu0YxEN9yu0aVNYuvmVKTba7h/Sz3/lqS3IdQ93AlK26kRGdbBz8By
	Zk9egiQQlFNOrARKOGkdrtSBpSvEkDdYoGIrnn5OTUbyqi1p7xR3r4WXf5k8mW+HimjT8gtz+UD
	xSRNLqEeVTQAc3/4aUxGvHU1W/VjgJHzfaZ9oCSJNEKJiNWpVXy71h4o=
X-Google-Smtp-Source: AGHT+IFy+SsvaSHRdbnflxzcQlgQCYz3IBbSgJxxHgkxgGzAV6KjiLv7yNcYRq+cK8DyyZtxlQZrgTbjP3aFM1U+sIF0b5l10DXH
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:608c:b0:7de:3f44:a6fe with SMTP id
 ca18e2360f4ac-7e1b519cfb4mr4772039f.1.1715317684278; Thu, 09 May 2024
 22:08:04 -0700 (PDT)
Date: Thu, 09 May 2024 22:08:04 -0700
In-Reply-To: <000000000000611ffc061800de0d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003fa9d106181285ed@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in __journal_res_get
From: syzbot <syzbot+c60cd352aedb109528bf@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 2d02bfb01b2743da06748ba396ff7da4425488ef
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Fri Jan 5 19:17:57 2024 +0000

    bcachefs: improve validate_bset_keys()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1232e998980000
start commit:   45db3ab70092 Merge tag '6.9-rc7-ksmbd-fixes' of git://git...
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1132e998980000
console output: https://syzkaller.appspot.com/x/log.txt?x=1632e998980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9d7ea7de0cb32587
dashboard link: https://syzkaller.appspot.com/bug?extid=c60cd352aedb109528bf
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15b795a8980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17592c00980000

Reported-by: syzbot+c60cd352aedb109528bf@syzkaller.appspotmail.com
Fixes: 2d02bfb01b27 ("bcachefs: improve validate_bset_keys()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

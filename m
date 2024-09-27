Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA40C2F2E
	for <linux-bcachefs@vger.kernel.org>; Fri, 27 Sep 2024 05:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727413444; cv=none; b=hExDgK9CQfWxCXuoHm0Ku/T2kp45DyClDACZKsulTOuv7WVfISahkI8KYhCdwowJkugK2eUXaXNiFaCJIyrBL2tMa49enis5tTrwQZnKMOP9Of9na5nOgnqVP7g78z+y6P7c7+bz72WAa546Qlnj/BNIGRyICB36MXtESdLDqZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727413444; c=relaxed/simple;
	bh=SjGBYvz7T0qkxE6kg8zLeZ7KNqVwseOD+H9h9Z901w0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=SHPwD8ziMBlmHUva+x7SBSj6za641HdkM7lQlHRgnMa3Vi66MCiwAOvJ6pPiRPjQV3oZhxlJqx0pEsee3lCO1YTRCuu4aZDRYIzhDbzzjaolSTTP+3P0gZ49xKDFoTQxEAOFtshLtlIJilc6fdLqbCth9VnXWKwIqe8zNrOS77A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a34205e146so14173315ab.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 26 Sep 2024 22:04:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727413442; x=1728018242;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+9q+IZMEdWfJPC4uwcDTgpH54G/AY8V67uzGME3VoSs=;
        b=wLeM6HJcyFS6ux5Bsf51TbaVFZk+z298PDrifgmYBV71A0L/ytw1NJSrZlDfVpXlFq
         TBOMHJ4P/94JYtOcSUoK4kF37BHinroutZR4HVb6lYuYxuoqxIHTiYCKboncq3DMyPkb
         N5ynrcQ7+ZXITkrVkFTwTuxZ//plS6vfZQb3/RqLVQpX1LQfrSjLviGe5Q6dDolVr9kz
         NRLuCZm2PnV1u/c0WVwq9omnm8+lcV3yoIad2W4u6qmIsgmTBrICzxc9wYzHahc2E2pU
         IAAzhSmuI7mKjg3tDeiQsKn4h1K3Igpn7CR5iwLzZYmVYj0mZNBiiSfFkd4K+/oZ3gxh
         NG4g==
X-Forwarded-Encrypted: i=1; AJvYcCWDbP9unBB3l/rzuZui9iQGsqJApmcjnXLpiDi3lyUeSUpEkWjHqRBCTzxfimoVFvYEhvguT2HSSSjVb8oahA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0OB/TCvkBpFIUobwa9nRuEcFhpQf7HpKj/NNNd9Jf6vamgXYY
	7li5tbCZwWVBiDvGslRtYZG5D0pBBUwzI0fq4g7pCBKhnyXvjoh6Uyq3dTVcqZcSLzjiFEjiQbU
	7ceMeJw6gYefLxOttgr5TbkkI21eU3HmBG/NIBertPAjWgZCnjIKAe5U=
X-Google-Smtp-Source: AGHT+IEuIThoMfjHlJmdIPHZix02yslTIlQF5/nyPzFqxMKfMlXxvSWsMpN3ijXL9qngDDvHLVpsU1YjSMkNcm8WIdZfwHbLF/CC
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a2e:b0:3a1:a20f:c09c with SMTP id
 e9e14a558f8ab-3a3451b9f82mr17499385ab.22.1727413441951; Thu, 26 Sep 2024
 22:04:01 -0700 (PDT)
Date: Thu, 26 Sep 2024 22:04:01 -0700
In-Reply-To: <a2f49743-4617-4655-ab4e-d94928368647@kylinos.cn>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66f63cc1.050a0220.46d20.000d.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in bch2_stripe_to_text
From: syzbot <syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	zhaomengmeng@kylinos.cn
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com
Tested-by: syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com

Tested on:

commit:         1ec6d097 Merge tag 's390-6.12-1' of git://git.kernel.o..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=11e94507980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6265dd30e362bb47
dashboard link: https://syzkaller.appspot.com/bug?extid=f8c98a50c323635be65d
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1503f627980000

Note: testing is done by a robot and is best-effort only.

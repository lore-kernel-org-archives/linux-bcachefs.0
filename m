Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634EC200B5
	for <linux-bcachefs@vger.kernel.org>; Thu, 19 Sep 2024 18:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726771384; cv=none; b=QzutFI5j1MwoYE0uhwiyW1YAMvhPqhKtyMz3cmohm32xOd3fdBoctuRcaJLVRrTzLv7z9MaXfKrBy+yh7pRjIM+sngU2/HW58byuw0I8ic00n5NmuneNxMZa+z3T+rxfPdHD7tmFLIDduDbnq1OweCAScssWwIMsgydxhW2ZTp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726771384; c=relaxed/simple;
	bh=17v9D7ewN9kAL3cNO0vf9+Ecs7x5/yWbSuqDJSadNTs=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=JpxwkKaisa8WCnkG8O1iTG3bbFrclQxQnSsRjmK02yO93sH9uCpUS2Her0CI2J+wX4Zt2YeeleTjLBb74wekUq4B7cokrzlkYwqCZmIvBCkgA2mZavs1pW5D6K0uFSbr1KwPVx2Eaa0br/FDdB8bNsEAxceE19nWr83W472HC0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a08c7d4273so15328835ab.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 19 Sep 2024 11:43:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726771382; x=1727376182;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o7lIsnCpfZQSVA6F2fRePR9yCTuruPmP5F+EBeyS/UE=;
        b=FOq5I4vgYuO+s9lkhGfLiZeLV1A6VU4Q8c4YvZC2yzJizMaUdJEA+NdmRDGpPc3DmR
         J2DJTDlMKlekugF2J+A7/6rP1x/NyrpTElSvnc/bn6M5XJwQH7Y0oI9XyAbzk3M9iESC
         /R7SdBz7bFa26F0qtpz4yLc9nvHF/PGPslQ58aLRki6IDMN54o6/KqufxmZYPVSbA0Yx
         q+7CpmEnfEySvqNET2jpDkkd658NI6mYRxmeZ6wZBY5YHXlUQMvgiohhD390p6ahJ2jm
         HAxXBpwip5oaeD08AMjIxXGgZusLzjkFdm45/mQx1zIsUS7D6irIfPOQwXMe8YJIwA7E
         cJwQ==
X-Forwarded-Encrypted: i=1; AJvYcCXgYJXBLPsqd1YlxjGof4Zygte6J4jh2U/4RRc59qcMo8zo5z2+jkAGfYxyw3NRpBvqMrX1XWZhFXIx9DdJTQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3fgSeEl7fM3rRIia9Kvp/c0dAfGIcka9XxqLTcXHX/zACNAY8
	dJnr4nMUVW1VAsTp4SHrKYTfZeIjA7WVHM4qksYRzmAkk9uu2pbxYbuQhJEruzjV4yrBLVEnetc
	Jo6yes50+riz9kIYGfIivCh6CXUj0a9mxZ4LyiBapY4Kpnx58ynqs4P0=
X-Google-Smtp-Source: AGHT+IENVGnXGP/szTaOFF3l8ixExEmfJzeszZrzEhNQFtrf0zBmFjgffCW64RLFf/aFcQsEEXsez6wa/Qx4m0ea8LQt6sj57l/5
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:180f:b0:3a0:98b2:8f3b with SMTP id
 e9e14a558f8ab-3a0c8ca77d2mr5551235ab.7.1726771382551; Thu, 19 Sep 2024
 11:43:02 -0700 (PDT)
Date: Thu, 19 Sep 2024 11:43:02 -0700
In-Reply-To: <tencent_50B5A5988DAD922A5D9B5DC9190C4FB08D07@qq.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66ec70b6.050a0220.29194.003f.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] BUG: unable to handle kernel paging request
 in bch2_opt_to_text
From: syzbot <syzbot+294f528e56138c357a48@syzkaller.appspotmail.com>
To: eadavis@qq.com, kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+294f528e56138c357a48@syzkaller.appspotmail.com
Tested-by: syzbot+294f528e56138c357a48@syzkaller.appspotmail.com

Tested on:

commit:         5f567360 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=17c8bb00580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dedbcb1ff4387972
dashboard link: https://syzkaller.appspot.com/bug?extid=294f528e56138c357a48
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
patch:          https://syzkaller.appspot.com/x/patch.diff?x=11886607980000

Note: testing is done by a robot and is best-effort only.

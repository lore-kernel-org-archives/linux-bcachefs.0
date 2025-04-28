Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E8427A135
	for <linux-bcachefs@vger.kernel.org>; Mon, 28 Apr 2025 16:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745858104; cv=none; b=C9c1MTgxxl7+zVmklOBuXZqa306dMm8WsXaXKu/BmQe2QsS1gxcLsbtdIeVCG7rBhyTNwiw5yBgOk0QCPsSA3nsSjfObdEIXf1c/t6nULRfzaL/NjOePYGyowsrwy42dgJDTY2EUXZeKFcJvmPHXOcxJgzmj+YoJR5rgOzNp/Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745858104; c=relaxed/simple;
	bh=yiIgGpFMHrWrqY91W1jx/2lbWpDB9chySq79yjUzOfw=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=serqm1OMAnyjLpI5XE8DlzRHudNHlow6J+tTMhpyQ8KYJ8ucOgDGPlOInwDkdxhil85SqsBRz0Drnfc9ubxpCeJ40v7367jA0BYSHo3ZdAOC8MJ6Jgt0BY5ISX+XhNnWBUarnJRKLYjF903CjatCXQPVH/+A7yp2lpEY+PjqAzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3d443811f04so41668905ab.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 28 Apr 2025 09:35:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745858102; x=1746462902;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d/r0GpshaiTfkf3Jzhs7+blVX9kV/2/sBukHf0VpE9M=;
        b=j5BsKYRFwD+Dw+Q/X2WFyz467tAWNwQ0DoGpxPX89UB+YQL+Ia1c0jLexpo6pUMWDs
         5PkkhZTrkubV0e+8j2RQp2naQgP176Y1f9w4mSRQ4Qs5qSnbsNhExMxSKGuVnT/Vntk8
         fj9oAEUpE38D5Dv9vtMcA7hogiAe0w5WpeH+HAA4e9I7SuoYmgOxzghFZ0QlNQgDGmAV
         Lo6dohwmW2e9Ruc8/PEpn9DRhqXiOw8T+TbqO3P9ulKHhfzDDThjmYzbrCZTmtTJL6bB
         aF1oBCeavG/8kQysKTGbR92osihML1tKKCyvKK1Ahz+5xNST2H8ecvSRoPTXXS+KZVsz
         okiQ==
X-Forwarded-Encrypted: i=1; AJvYcCV3UtwuS19TW+BJixqNUjMiBECV3wGt7+aZ5X5zYEtdZdvu4gbdlzjNFgZJyBXtEilDB60BU0REzcNk+5mO/Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YxQyo4C1WNToAfrRj2qmVQxsbOSf67tZlS/1kOLsVX8UPApHcnh
	oXb3Hw8DLbjS5ljD4vmRmm1586tvS8xZpNCxg85TkA1Mj/+XFZf6bO5q29HPskZyu8hcTLNG7Pv
	aWtItGn/9EDpHN9XDT2Txl/GqmX0GdzoSKaq3sI8R8+QVmrAM106Y21o=
X-Google-Smtp-Source: AGHT+IEgs1qYfXWS2ROxH3BfjLzrfX+CmIh0fNFRmiQySnncSit5H10zcDnfsSDAyjMguuYw+sYMK8bOyi6cK0c5LgqfxiKU/X9+
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1689:b0:85b:538e:1fad with SMTP id
 ca18e2360f4ac-86467b1071amr1053843739f.6.1745858102043; Mon, 28 Apr 2025
 09:35:02 -0700 (PDT)
Date: Mon, 28 Apr 2025 09:35:02 -0700
In-Reply-To: <20250428160903.20110-1-contact@arnaud-lcm.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <680fae36.a70a0220.23e4d2.0032.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in __bch2_str_hash_check_key
From: syzbot <syzbot+843981bb836d699c07d1@syzkaller.appspotmail.com>
To: contact@arnaud-lcm.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+843981bb836d699c07d1@syzkaller.appspotmail.com
Tested-by: syzbot+843981bb836d699c07d1@syzkaller.appspotmail.com

Tested on:

commit:         b4432656 Linux 6.15-rc4
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=150dd270580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a33ce5560507649
dashboard link: https://syzkaller.appspot.com/bug?extid=843981bb836d699c07d1
compiler:       Debian clang version 20.1.2 (++20250402124445+58df0ef89dd6-1~exp1~20250402004600.97), Debian LLD 20.1.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=11d7e368580000

Note: testing is done by a robot and is best-effort only.

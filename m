Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ACA535961
	for <linux-bcachefs@vger.kernel.org>; Fri, 11 Apr 2025 15:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744386726; cv=none; b=ap4SgVNiqYDgZdoAgnSnd/8OEoBxIouUjnFEaJB6v2p6Qbctn20v6MZvh15H34cmdIQJX+yrVGReIW9N2fPUh4RDby1HrGyzOhIhe8t3Iu7/SuM/PQqM2plv+INvk1D5OPTG45J5g8nDIbpX+BIBrallgc8606HXUh3rYCUMhEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744386726; c=relaxed/simple;
	bh=Cm1S8n4HvXkNg3M7+x98S/klYnfkLdVLWBGBf4WpcLo=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=e5K6WlLi5ZsDuVL1U4OKHgv29DItVy/hlKKV7bc2te9BIuZyk2MQN6zYrnzAhZ/9WuCNIxFapKuM8eFP1dwuP/HK8HVZ7HoZnggKsjP7pe5lvqoX+GFZp5st12Ycx8RVcAVZGG/k4aoEtIyLu8gdgw4C6/nFanTeYnDiuMXlOho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-8610d7ec4d3so392581739f.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 11 Apr 2025 08:52:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744386724; x=1744991524;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j9Rm20tgPIVlasLY5+mlUVDiqqosCGRBLcfWz2QKiWw=;
        b=OEHpj8sh25UX9y+C/NfycJOQN+EIpM1w6GA87xLR8QTX19nlSvbQ5qtYrpSRbenTEQ
         Fd61Ak35Q5QWFlOycIGy0ZaEuDIRnSgvKQMLxvfX9JLJY85bziQt1sYNnJF3oFZDvdmq
         DHQTH5QrpsvagMgCw+Q8JzJBKfjCvhiiZEFb24bzTqkicu4gU8EjYLWTAcwQtpxFuA/4
         03OZxDa7uyXqvf2s8AR2l0ORvRmJyCf6UqsaImY9r80vseVrXLv0wE1ojufA3PufLfji
         wIT1/2MtUcF0FGRE73nnk38HkICL1wUtP34DSpFn4G8Li8aF1skH5kQC4KkUzHjofc28
         prgg==
X-Forwarded-Encrypted: i=1; AJvYcCUglW7JHCWzesmaCbsgSfjz+GKZLJgPwxn6Y05gDzLR4A3uziHja2h9b9XDjxFfxecwDii8vf+OtpjuIC14jw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxFK9nOJR5sXfrdDIP1sl6vM6Zi/IRDs7v/rxBdG6evmx12srZP
	5cJSiil8O5oo8UW6GXwqVdMXjsUmexfZSWZfQbF3jiJrfAna1VC80I/ZqNdaM3ltpydNTNe6rs1
	4EwMtN/SnZri/zUlnEyQoXiBJAJo4qO6hyCznoG58zX1ZeuizTryOahQ=
X-Google-Smtp-Source: AGHT+IGl5gBtzIhGcLfzPKV03qwQ0UJaaZQFsriMvDyR9hHnL1GiKpgBiHaW2VNixnElsnhBjWSXs8jCrtNIC+BjcGXAyHE412g6
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b25:b0:3d4:244b:db1d with SMTP id
 e9e14a558f8ab-3d7ec2033cbmr31096595ab.6.1744386723815; Fri, 11 Apr 2025
 08:52:03 -0700 (PDT)
Date: Fri, 11 Apr 2025 08:52:03 -0700
In-Reply-To: <m2o6x2r9s1.fsf@posteo.net>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67f93aa3.050a0220.2c5fcf.0000.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] general protection fault in bch2_snapshot_tree_oldest_subvol
From: syzbot <syzbot+baee8591f336cab0958b@syzkaller.appspotmail.com>
To: charmitro@posteo.net, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
unregister_netdevice: waiting for DEV to become free

unregister_netdevice: waiting for batadv0 to become free. Usage count = 3


Tested on:

commit:         900241a5 Merge tag 'drm-fixes-2025-04-11-1' of https:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1314c870580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fb8650d88e9fb80f
dashboard link: https://syzkaller.appspot.com/bug?extid=baee8591f336cab0958b
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=16f08870580000


Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C7CC433EF
	for <linux-bcachefs@archiver.kernel.org>; Wed, 10 Nov 2021 12:02:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FBE661168
	for <linux-bcachefs@archiver.kernel.org>; Wed, 10 Nov 2021 12:02:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbhKJMFQ (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 10 Nov 2021 07:05:16 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:38846 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbhKJME6 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 10 Nov 2021 07:04:58 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 51D5721B19;
        Wed, 10 Nov 2021 12:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636545730; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=95lox8Uc/yNZ4a546soVl+QHM0tGJUMU+MjS+ACCYgE=;
        b=CaRVeBCEPCO2BY9QioQoe6u+rYwAcsACaBK2FYfR0bj5EiDAojJxBKlDdeZmCkaORoFY+k
        aFafIlAR2dgmj8QDoCFaLkoxiz44sU0votzh5LXBMF9HHEVzKMEOz533FYVdtyEf112/Cl
        EUnGk0JbdmLRACC6+yNYT4Nr+eMUCwI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636545730;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=95lox8Uc/yNZ4a546soVl+QHM0tGJUMU+MjS+ACCYgE=;
        b=ECtGw62IoY37+/sGH0HIIU6IOI4dI+HtTVYLE0qZCC5aP9OrXx8E6B4ZE7F+2+FUHuTf9U
        1XwlcrcVeiKv+6Dg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D951513BEA;
        Wed, 10 Nov 2021 12:02:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id wwE2KcC0i2EibQAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 10 Nov 2021 12:02:08 +0000
Message-ID: <84ff96fe-ff4b-b58b-b732-88e87fe0b502@suse.de>
Date:   Wed, 10 Nov 2021 20:02:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: bug in bcachefs -> bio_copy_data_iter
Content-Language: en-US
To:     hch@lst.de, Kent Overstreet <kent.overstreet@gmail.com>
Cc:     ming.lei@redhat.com, linux-bcachefs@vger.kernel.org
References: <YYrwbksSPdtITbEs@moria.home.lan>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <YYrwbksSPdtITbEs@moria.home.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On 11/10/21 6:04 AM, Kent Overstreet wrote:
> Hey Christoph, got a strange one.
>
> I've got a user that's reporting a bug where we deref a bad ptr in bio_copy_data
> -> memcpy, and reverting your patch "block: rewrite bio_copy_data_iter to use
> bvec_kmap_local and memcpy_to_bvec" seems to make it go away.
>
> I haven't figured out what's different yet between the two versions (your patch
> looks like it should be functionally equivalent), but clearly I'm missing
> something... wonder if there might be some relation to the bug you guys hit in
> bcache with bvec_virt.
>
> Any ideas?

I experience similar one in bcache code during my recent development,

[ 3134.522913] BUG: unable to handle page fault for address: 
ffffa100e2eaa3f8^M
[ 3134.605187] #PF: supervisor read access in kernel mode^M
[ 3134.666654] #PF: error_code(0x0000) - not-present page^M
[ 3134.728124] PGD 523c805067 P4D 523c805067 PUD 5b35ea1067 PMD 
5b35d89067 PTE 800ffffb5d155060^M
[ 3134.829113] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC NOPTI^M
[ 3134.889545] CPU: 3 PID: 458 Comm: kworker/3:2 Kdump: loaded Tainted: 
G            EL    5.15.0-59.27-default+ #15^M
[ 3135.012373] Hardware name: Lenovo ThinkSystem SR650 
-[7X05CTO1WW]-/-[7X05CTO1WW]-, BIOS -[IVE164L-2.80]- 10/23/2020^M
[ 3135.137281] Workqueue: bcache cached_dev_read_done [bcache]^M
[ 3135.203970] RIP: 0010:bio_copy_data_iter+0x1a8/0x260^M
[ 3135.263365] Code: 8d 04 3e 48 3d 00 10 00 00 0f 87 a3 00 00 00 4c 01 
f9 41 83 f8 08 0f 82 89 fe ff ff 48 8b 06 48 8d 79 08 48 83 e7 f8 48 89 
01 <4a> 8b 44 36 f8 4a 89 44 31 f8 48 29 f9 48 29 ce 44 01 c1 c1 e9 03^M
[ 3135.488114] RSP: 0018:ffffba1607fcbdb8 EFLAGS: 00010282^M
[ 3135.550624] RAX: 0000000000000000 RBX: ffffa0ff6912f968 RCX: 
ffffa0fe22626000^M
[ 3135.636012] RDX: ffffa0ffa8cc4160 RSI: ffffa100e2ea9400 RDI: 
ffffa0fe22626008^M
[ 3135.721402] RBP: 0000000000001000 R08: 0000000000001000 R09: 
0000000000000c00^M
[ 3135.806793] R10: ffffba1607fcbdf8 R11: ffffba1607fcbe10 R12: 
ffffa0fc40000000^M
[ 3135.892180] R13: ffffe04500000000 R14: 0000000000001000 R15: 
0000000000000000^M
[ 3135.977570] FS:  0000000000000000(0000) GS:ffffa1084b000000(0000) 
knlGS:0000000000000000^M
[ 3136.074399] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033^M
[ 3136.143147] CR2: ffffa100e2eaa3f8 CR3: 000000036854c003 CR4: 
00000000007706e0^M
[ 3136.228538] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000^M
[ 3136.313926] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400^M
[ 3136.399317] PKRU: 55555554^M
[ 3136.431665] Call Trace:^M
[ 3136.460896]  bio_copy_data+0x5e/0x80^M
[ 3136.503647]  cached_dev_read_done+0xa8/0x210 [bcache]^M
[ 3136.564082]  process_one_work+0x2e3/0x640^M
[ 3136.612034]  worker_thread+0x39/0x400^M
[ 3136.655824]  ? process_one_work+0x640/0x640^M
[ 3136.705854]  kthread+0x13c/0x160^M
[ 3136.744442]  ? set_kthread_struct+0x40/0x40^M
[ 3136.794471]  ret_from_fork+0x22/0x30^M



Coly Li

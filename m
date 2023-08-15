Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB62C0015E
	for <linux-bcachefs@archiver.kernel.org>; Tue, 15 Aug 2023 18:01:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238970AbjHOSBJ (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 15 Aug 2023 14:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239022AbjHOSBA (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 15 Aug 2023 14:01:00 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 658DB138
        for <linux-bcachefs@vger.kernel.org>; Tue, 15 Aug 2023 11:00:59 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 23BEE1F8CC;
        Tue, 15 Aug 2023 18:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1692122458; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XLo3wFGGhA1/PKBAYpRWU8WdXeA/ziHWjFrqSBtFyTQ=;
        b=BgobZc6V7rHixNgKGvYNekYSE6qtFw7MCIsyg6kg0dSM2JhFbmXYvHh61qGG2mL/2CJI9w
        yMI2kNdxTeBCaXXk4ln6SnABt5Iyi6hV21qLeqvEaE1OM7+8RaliifRJSifhnQE/zK69bY
        NDzOq1FEPUSRPzLP7zReThVxzlTRBas=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1692122458;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XLo3wFGGhA1/PKBAYpRWU8WdXeA/ziHWjFrqSBtFyTQ=;
        b=LjW5cWnRCqDF2LEtsHJRSlxwM4m0tx2bHTZSCdyNULzhvErgm01DvrHsOMp5GOrm7kTqos
        A0iiOsb/yv+iDGBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E121C1353E;
        Tue, 15 Aug 2023 18:00:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id D1xmMVm922QhOwAAMHmgww
        (envelope-from <krisman@suse.de>); Tue, 15 Aug 2023 18:00:57 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     Joshua Ashton <joshua@froggi.es>, linux-bcachefs@vger.kernel.org,
        =?utf-8?Q?Andr=C3=A9?= Almeida <andrealmeid@igalia.com>
Subject: Re: [v4 3/3] bcachefs: Implement casefolding
In-Reply-To: <20230815005837.figd3mlz7if4w6oo@moria.home.lan> (Kent
        Overstreet's message of "Mon, 14 Aug 2023 20:58:37 -0400")
Organization: SUSE
References: <20230814012434.627641-1-joshua@froggi.es>
        <20230814012434.627641-4-joshua@froggi.es> <87v8dh60rd.fsf@suse.de>
        <8ffb410c-ebfc-490c-96d8-8ed72ef8eee2@froggi.es>
        <20230815005837.figd3mlz7if4w6oo@moria.home.lan>
Date:   Tue, 15 Aug 2023 14:00:56 -0400
Message-ID: <87sf8k423r.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Kent Overstreet <kent.overstreet@linux.dev> writes:

> On Mon, Aug 14, 2023 at 10:18:33PM +0100, Joshua Ashton wrote:
>
>> Grepping the test right now I already know we will fail the
>> `test_casefold_flag_removal` test as we don't support toggling the flag =
on
>> non-empty directories as it would require rehashing and thus restructuri=
ng
>> the btree.
>
> What was the motivation for supporting that on other filesystems? I'm
> not inclined to add that to bcachefs without a good reason.

I don't think there was a better reason than "it is user-friendly to
allow disabling the feature without having to remove the
directory". Note that it is trivial to do so in empty directories for
ext4/f2fs: it is just a matter of flipping a bit in the inode to
enable/disable casefolding.

I think it's ok for the Windows games to not allow disabling
case-insensitive once it is set for a directory.  For fstests, I suppose
the easiest solution would be to skip that subtest when running on
bcachefs.

>> > Sure, if you have both, dirent and dentry->d_name casefolded, then it =
is
>> > just a regular memcmp, but at least you don't have to change the disk
>> > format and your implementation becomes simpler.
>> >=20
>>=20
>> Given we have the opportunity to have support for this in the dirent for=
mat
>> for bcachefs, I think it makes sense to take it right now.
>
> It also means that we have the option of defining a casefolding map that
> handles =C3=9F correctly.

What do you mean by handling =C3=9F correctly?  do you intend to support NF=
KD
normalization?  We can extend fs/unicode/ for that fairly easily,
but iirc, other filesystems decided to stick with NFD, because NFKD is
a bit too eager when folding some characters.

>> > > +#if IS_ENABLED(CONFIG_UNICODE)
>> > > +	struct unicode_map 	*cf_encoding;
>> > > +#endif
>> >=20
>> > This goes in struct super_block.
>>=20
>> The code in libfs.c that uses the s_encoding in the super_block is never
>> used for bcachefs as it defines its own inode_operations and doesn't use=
 any
>> of the libfs common code for lookups/hashes there (ie. the
>> dentry_operations).
>>=20
>> One thing we wanted to do down the line was to use the bcachefs options
>> system to be able to pick the encoding on a per-inode basis.
>>=20
>> Currently I am storing it in the struct bch_fs as currently there is no =
need
>> for other encodings right now and it is convenient, so there can only be=
 one
>> -- but that could change at some point with an opt attached to the inode.
>>=20
>> I am happy to bung it in the vfs super_block for now though -- but I nee=
d to
>> look at how that all works out with mounting and the multiple drives
>> situation. Just be aware that at some point, it will likely be moved back
>> again to our code.
>
> We also don't always have a super_block available when we have a running
> bch_fs object (e.g. when running in userspace, for fsck and various
> other tools). Since s_encoding is used in dirent.c, it probably needs to
> be in bch_fs.

Ah, I didn't know this is reused for userspace tools.  Still, as long as
you initialize sb->s_encoding at mount time, libfs helpers will work fine.

--=20
Gabriel Krisman Bertazi

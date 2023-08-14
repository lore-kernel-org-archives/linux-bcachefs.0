Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 505ABC41513
	for <linux-bcachefs@archiver.kernel.org>; Mon, 14 Aug 2023 21:34:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbjHNVeH (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 14 Aug 2023 17:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232358AbjHNVeB (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 14 Aug 2023 17:34:01 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD9411D
        for <linux-bcachefs@vger.kernel.org>; Mon, 14 Aug 2023 14:33:59 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-317b31203c7so4477399f8f.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 14 Aug 2023 14:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=froggi.es; s=google; t=1692048837; x=1692653637;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H4GVl8gcL2YdNnCi8ErNG9POrmiZyemuscSu9mI8atc=;
        b=VlGgRre1tvLBlfAQZmksNrccggaNb4BRk00dIqp2MeJnwM+F8Q1OTnI8qWuJaUlQyT
         1kbhsj179UoYatM44ae9QIZh0zJ4Hk2akDhbTqOWr1x5/cyaspDmxBm195InKvy49pf8
         IgMXvyhVvzLYyjFe25p1ovMMlejR3xo89MODAiiR1M27ZtN9UZqnJ12SW1Q2CwBLsNPj
         JXb3+t+etv/Z/AXcJcPTUlUvICT2F1di3/XYWVNYyf7l0O0ne+vaWQqp1lVHYF5ZDho5
         KWkctsooVl8q0YQsz2IuDLOVeIPod6qQs5p8mB/M26iVYyMTgFq8c0PxzmXyg+xrvHas
         GuDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692048837; x=1692653637;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H4GVl8gcL2YdNnCi8ErNG9POrmiZyemuscSu9mI8atc=;
        b=FATZe6/Ija5bkcbvK+xF52kYKEjeLNV3xHoQUfOE38unfMpm+8N3f42EAE/8kgHg+q
         9hBMAt9Yxg0VJJ0AwFqQ6jJ1RZHKfjfzJpx9ICCpAAx0+lhcyEnWYiZ873obbzUhztGr
         YU/HeDfBBJ5l3OUrgJN+AISGy5ye9wMUN96/VWGu7z3/7gqSK79l2zLTWCw8i0ScaShE
         wiH5Dz7QmYgoJY9qEFQ6oVckii7q1Pa0Jwo0LZp5fSG2aeCBf/2gHUbxgcg2frpn1yzM
         cepoz7W/5NpBgIN3d9dKkmvcswIJF8ER+kgzzX82V+FDaF8hDh+z9XIamt8AXity+fiw
         NxPw==
X-Gm-Message-State: AOJu0YzzUFMQxk5BkPl0HrIk+o8ErBKUTfn8wVB6Y8712u2AsI4OCQmD
        NOGZuOL5dl2WNQe9W5NG4f+om5G4EKoqwN9ok/8=
X-Google-Smtp-Source: AGHT+IHhP68CKues0svHYee1rtbrEIarHQ9h8Nfye14HdJQqriNk3QCInrXapEbxIBBVrPJIXI9bqA==
X-Received: by 2002:adf:f591:0:b0:319:6b5e:85e3 with SMTP id f17-20020adff591000000b003196b5e85e3mr4902969wro.71.1692048837472;
        Mon, 14 Aug 2023 14:33:57 -0700 (PDT)
Received: from [192.168.0.89] (darl-09-b2-v4wan-165404-cust288.vm5.cable.virginm.net. [86.17.61.33])
        by smtp.gmail.com with ESMTPSA id u1-20020a7bc041000000b003fd2e89620asm18278859wmc.40.2023.08.14.14.33.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Aug 2023 14:33:57 -0700 (PDT)
Message-ID: <4e8e6443-1f72-48e5-8725-3bf47dd9a3ab@froggi.es>
Date:   Mon, 14 Aug 2023 22:33:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v4 3/3] bcachefs: Implement casefolding
Content-Language: en-US
From:   Joshua Ashton <joshua@froggi.es>
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     linux-bcachefs@vger.kernel.org,
        =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
References: <20230814012434.627641-1-joshua@froggi.es>
 <20230814012434.627641-4-joshua@froggi.es> <87v8dh60rd.fsf@suse.de>
 <8ffb410c-ebfc-490c-96d8-8ed72ef8eee2@froggi.es>
In-Reply-To: <8ffb410c-ebfc-490c-96d8-8ed72ef8eee2@froggi.es>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org



On 8/14/23 22:18, Joshua Ashton wrote:
> 
> 
> On 8/14/23 17:34, Gabriel Krisman Bertazi wrote:
>> Joshua Ashton <joshua@froggi.es> writes:
>>
>>> This patch implements support for case-insensitive file name lookups
>>> in bcachefs.
>>>
>>> The implementation uses the same UTF-8 lowering and normalization that
>>> ext4 and f2fs is using.
>>>
>>> More information is provided in Documentation/bcachefs/casefolding.rst
>>>
>>> Signed-off-by: Joshua Ashton <joshua@froggi.es>
>>
>> Please, cc the entire thread as i don't think I even got the cover
>> letter.
> 
> Thanks, I will for v5.
> 
>>
>> Did you test this against fstests generic/556?  it checks all sorts of
>> common pitfalls and corner-cases in case-insensitive filesystems.
> 
> No, I wrote my own casefolding test that tests a bunch of edgecases.
> 
> I was not aware there were any casefolding tests in fstests -- I really 
> really wish they had better names. :/
> 
> Grepping the test right now I already know we will fail the 
> `test_casefold_flag_removal` test as we don't support toggling the flag 
> on non-empty directories as it would require rehashing and thus 
> restructuring the btree.
> 
> There's a lot of edgecases to handle there (such as hash collisions) 
> which are pretty gnarly to solve when doing something like that.
> 
> I diiiid try and implement something that did that, but it really did 
> not end well... ^^;; So planning to defer this for now.
> 
>>
>>> --- /dev/null
>>> +++ b/Documentation/filesystems/bcachefs/casefolding.rst
>>> @@ -0,0 +1,73 @@
>>> +.. SPDX-License-Identifier: GPL-2.0
>>> +
>>> +Casefolding
>>> +===========
>>> +
>>> +bcachefs has support for case-insensitive file and directory
>>> +lookups using the regular `chattr +F` (`S_CASEFOLD`, `FS_CASEFOLD_FL`)
>>> +casefolding attributes.
>>> +
>>> +The main usecase for casefolding is compatibility with software written
>>> +against other filesystems that rely on casefolded lookups
>>> +(eg. NTFS and Wine/Proton).
>>> +Taking advantage of file-system level casefolding can lead to great
>>> +loading time gains in many applications and games.
>>> +
>>> +Casefolding support requires a kernel with the `CONFIG_UNICODE` 
>>> enabled.
>>> +Once a directory has been flagged for casefolding, a feature bit
>>> +is enabled on the superblock which marks the filesystem as using
>>> +casefolding.
>>> +When the feature bit for casefolding is enabled, it is no longer 
>>> possible
>>> +to mount that filesystem on kernels without `CONFIG_UNICODE` enabled.
>>> +
>>> +On the lookup/query side: casefolding is implemented by allocating a 
>>> new
>>> +string of `BCH_NAME_MAX` length using the `utf8_casefold` function to
>>> +casefold the query string.
>>> +
>>> +On the dirent side: casefolding is implemented by ensuring the `bkey`'s
>>> +hash is made from the casefolded string and storing the cached 
>>> casefolded
>>> +name with the regular name in the dirent.
>>> +
>>> +The structure looks like this:
>>> +
>>> +Regular:    [dirent data][regular name][nul][nul]...
>>> +Casefolded: [dirent data][reg len][cf len][regular name][casefolded 
>>> name][nul][nul]...
>>> +
>>> +(Do note, the number of `NUL`s here is merely for illustration, they 
>>> count can vary
>>> + per-key, and they may not even be present if the key is aligned to 
>>> `sizeof(u64)`.)
>>> +
>>> +This is efficient as it means that for all file lookups that require 
>>> casefolding,
>>> +it has identical performance to a regular lookup:
>>> +a hash comparison and a `memcmp` of the name.
>>> +
>>> +Rationale
>>> +---------
>>> +
>>> +Several designs were considered for this system:
>>> +One was to introduce a dirent_v2, however that would be painful 
>>> especially as
>>> +the hash system only has support for a single key type. This would 
>>> also need
>>> +`BCH_NAME_MAX` to change between versions, and a new feature bit.
>>> +
>>> +Another option was to store without the two lengths, and just take 
>>> the length of
>>> +the regular name and casefolded name contiguously / 2 as the length. 
>>> This would
>>> +assume that the regular length == casefolded length, but that could 
>>> potentially
>>> +not be true, if the uppercase unicode glyph had a different UTF-8 
>>> encoding than
>>> +the lowercase unicode glyph.
>>
>> Why do you want to store the casefolded name?  In ext4, we just store
>> the case-exact name that was created, and do a code-point by code-point
>> comparison with the name under lookup through utf8_strncasecmp, which is
>> optimized to compare two not casefolded strings.  We just modify the
>> filename hash to be case-insensitive, so we know which dirent to look
>> for during lookup.  Finally, we use d_compare/d_hash to leverage the
>> dcache into finding negative dentries.
> 
> Yeah, am aware of how ext4 does it, I just wanted it to have basically 
> the exact same performance characteristics as as regular lookup.
> 
> The utf8 cursor stuff in utf8_strncasecmp is still super expensive 
> compared to a straight memcmp in some local benching.
> 
>>
>> Sure, if you have both, dirent and dentry->d_name casefolded, then it is
>> just a regular memcmp, but at least you don't have to change the disk
>> format and your implementation becomes simpler.
>>
> 
> Given we have the opportunity to have support for this in the dirent 
> format for bcachefs, I think it makes sense to take it right now.
> 
>>
>>
>>> +It would be possible to disregard the casefold cache for those 
>>> cases, but it was
>>> +decided to simply encode the two string lengths in the key to avoid 
>>> random
>>> +performance issues if this edgecase was ever hit.
>>> +
>>> +The option settled on was to use a free-bit in d_type to mark a 
>>> dirent as having
>>> +a casefold cache, and then treat the first 4 bytes the name block as 
>>> lengths.
>>> +You can see this in the `d_cf_name_block` member of union in 
>>> `bch_dirent`.
>>> +
>>> +The feature bit was used to allow casefolding support to be enabled 
>>> for the majority
>>> +of users, but some allow users who have no need for the feature to 
>>> still use bcachefs as
>>> +`CONFIG_UNICODE` can increase the kernel side a significant amount 
>>> due to the tables used,
>>> +which may be decider between using bcachefs for eg. embedded platforms.
>>> +
>>> +Other filesystems like ext4 and f2fs have a super-block level option 
>>> for casefolding
>>> +encoding, but bcachefs currently does not provide this. ext4 and 
>>> f2fs do not expose
>>> +any encodings than a single UTF-8 version. When future encodings are 
>>> desirable,
>>> +they will be added trivially using the opts mechanism.
>>> +
>>> diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
>>> index 30b3d7b9f9dc..0e1facdc7876 100644
>>> --- a/fs/bcachefs/bcachefs.h
>>> +++ b/fs/bcachefs/bcachefs.h
>>> @@ -202,6 +202,7 @@
>>>   #include <linux/types.h>
>>>   #include <linux/workqueue.h>
>>>   #include <linux/zstd.h>
>>> +#include <linux/unicode.h>
>>>   #include "bcachefs_format.h"
>>>   #include "errcode.h"
>>> @@ -657,6 +658,8 @@ enum bch_write_ref {
>>>       BCH_WRITE_REF_NR,
>>>   };
>>> +#define BCH_FS_DEFAULT_UTF8_ENCODING UNICODE_AGE(12, 1, 0)
>>> +
>>>   struct bch_fs {
>>>       struct closure        cl;
>>> @@ -723,6 +726,9 @@ struct bch_fs {
>>>           u64        compat;
>>>       }            sb;
>>> +#if IS_ENABLED(CONFIG_UNICODE)
>>> +    struct unicode_map     *cf_encoding;
>>> +#endif
>>
>> This goes in struct super_block.
> 
> The code in libfs.c that uses the s_encoding in the super_block is never 
> used for bcachefs as it defines its own inode_operations and doesn't use 
> any of the libfs common code for lookups/hashes there (ie. the 
> dentry_operations).
> 
> One thing we wanted to do down the line was to use the bcachefs options 
> system to be able to pick the encoding on a per-inode basis.
> 
> Currently I am storing it in the struct bch_fs as currently there is no 
> need for other encodings right now and it is convenient, so there can 
> only be one -- but that could change at some point with an opt attached 
> to the inode.
> 
> I am happy to bung it in the vfs super_block for now though -- but I 
> need to look at how that all works out with mounting and the multiple 
> drives situation. Just be aware that at some point, it will likely be 
> moved back again to our code.
> 
>>
>>
>>> @@ -13,8 +13,39 @@
>>>   #include <linux/dcache.h>
>>> -static inline unsigned dirent_val_u64s(unsigned len)
>>> +static inline int bch2_casefold(struct btree_trans *trans, const 
>>> struct bch_hash_info *info,
>>> +                const struct qstr *str, struct qstr *out_cf)
>>>   {
>>> +#if IS_ENABLED(CONFIG_UNICODE)
>>> +    unsigned char *buf = NULL;
>>> +    int ret;
>>> +
>>> +    *out_cf = (struct qstr) QSTR_INIT(NULL, 0);
>>> +
>>> +    buf = bch2_trans_kmalloc(trans, BCH_NAME_MAX + 1);
>>> +    ret = PTR_ERR_OR_ZERO(buf);
>>> +    if (ret)
>>> +        return ret;
>>> +
>>> +    ret = utf8_casefold(info->cf_encoding, str, buf, BCH_NAME_MAX + 1);
>>> +    if (ret <= 0)
>>> +        return ret;
>>
>> The error path leaks buf.
> 
> trans_kmalloc does not need to be freed.
> 
>>
>>> @@ -472,6 +600,7 @@ int __bch2_dirent_lookup_trans(struct btree_trans 
>>> *trans,
>>>                      const struct qstr *name, subvol_inum *inum,
>>>                      unsigned flags)
>>>   {
>>> +    struct qstr lookup_name = *name;
>>>       struct bkey_s_c k;
>>>       struct bkey_s_c_dirent d;
>>>       u32 snapshot;
>>> @@ -481,8 +610,14 @@ int __bch2_dirent_lookup_trans(struct 
>>> btree_trans *trans,
>>>       if (ret)
>>>           return ret;
>>> +    ret = hash_info->cf_encoding
>>> +        ? bch2_casefold(trans, hash_info, name, &lookup_name)
>>> +        : 0;
>>> +    if (ret)
>>> +        return ret;
>>> +
>>>       ret = bch2_hash_lookup(trans, iter, bch2_dirent_hash_desc,
>>> -                   hash_info, dir, name, flags);
>>> +                   hash_info, dir, &lookup_name, flags);
>>>       if (ret)
>>>           return ret;
>>
>>
>> (Skipping the bcachefs-specific bits that I'm not qualified to review)
>>
>> I don't get your model for the dcache.  I don't see any handling
>> anywhere in the patch.  Also, I fetched the code and it seems bcachefs
>> will just do d_splice_alias at the end of the lookup. So, when someone
>> lookups FOO, ->lookup will be called and the dentry FOO will be created.
>> Then, when FOo is looked up, the dcache won't find the previous dentry
>> and ->lookup will be called again (perhaps creating another dentry?)
>>
>> There are two ways around it. Rely on the libfs' generic handlers for
>> d_hash/d_compare and soon d_revalidate, or use d_add_ci to search for
>> case-insensitive aliases at lookup time, but then you don't benefit much
>> from the dcache if looking up for different cases.
> 
> Thanks for the heads-up on this.
> 
> It seems like I may have potentially hit a foot-gun there if we are 
> making vfs dentry's for each lookup.
> 
> I will investigate and validate that we are doing the right thing here 
> for the next revision.
> 
> I will not lie, I know veeery little about the vfs or dcache side, so 
> huge thanks for pointing this out to me. :)
> 
> I had a quick look at what f2fs does here, and it seems like it also 
> just does d_splice_alias, but it has the following caveat.
> 
> [f2fs code]
> #if IS_ENABLED(CONFIG_UNICODE)
>      if (!inode && IS_CASEFOLDED(dir)) {
>          /* Eventually we want to call d_add_ci(dentry, NULL)
>           * for negative dentries in the encoding case as
>           * well.  For now, prevent the negative dentry
>           * from being cached.
>           */
>          trace_f2fs_lookup_end(dir, dentry, ino, err);
>          return NULL;
>      }
> #endif
>      new = d_splice_alias(inode, dentry);
> 
> I won't even pretend that I understand what a negative dentry is right 
> now... :D

I am guessing we probably want something like:

bch2_dirent_lookup -> returns feedback to a `struct qstr real_name` with 
the actual name if it was not identical to the dentry lookup name.

if (real_name.len) {
      d_add_ci(dentry, vinode, &real_name);
      return dentry;
} else {
      return d_splice_alias(vinode, dentry);
}

Is my line of thinking correct here?

- Joshie 🐸✨

> 
>>
>>
>>> @@ -54,6 +54,28 @@ static int bch2_inode_flags_set(struct btree_trans 
>>> *trans,
>>>           (newflags & (BCH_INODE_NODUMP|BCH_INODE_NOATIME)) != newflags)
>>>           return -EINVAL;
>>> +    if ((newflags ^ oldflags) & BCH_INODE_CASEFOLDED) {
>>> +#if IS_ENABLED(CONFIG_UNICODE)
>>> +        int ret = 0;
>>> +        /* Not supported on individual files. */
>>> +        if (!S_ISDIR(bi->bi_mode))
>>> +            return -EOPNOTSUPP;
>>> +
>>> +        /*
>>> +         * Make sure the dir is empty, as otherwise we'd need to
>>> +         * rehash everything and update the dirent keys.
>>> +         */
>>> +        ret = bch2_empty_dir_trans(trans, inode_inum(inode));
>>> +        if (ret < 0)
>>> +            return ret;
>>> +
>>> +        bch2_check_set_feature(c, BCH_FEATURE_casefolding);
>>
>> fwiw, we use _CASEFOLD in other filesystems, not _casefolding.
> 
> bcachefs features are always lowercase, but I can change the name of it 
> to _casefold.
> 
> - Joshie 🐸✨
> 
>>
>> Thanks,
>>
> 



Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1707E743F6
	for <linux-bcachefs@archiver.kernel.org>; Fri, 29 Sep 2023 08:27:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232621AbjI2I1N (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 29 Sep 2023 04:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232663AbjI2I1M (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 29 Sep 2023 04:27:12 -0400
X-Greylist: delayed 711 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 29 Sep 2023 01:27:07 PDT
Received: from relay-b02.edpnet.be (relay-b02.edpnet.be [212.71.1.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4421AC
        for <linux-bcachefs@vger.kernel.org>; Fri, 29 Sep 2023 01:27:07 -0700 (PDT)
X-ASG-Debug-ID: 1695975312-214fdf53d211e130001-qsCQDO
Received: from [192.168.177.53] (212.71.9.157.dyn.edpnet.net [212.71.9.157]) by relay-b02.edpnet.be with ESMTP id IJoCbvb2ypDjAz6m; Fri, 29 Sep 2023 10:15:12 +0200 (CEST)
X-Barracuda-Envelope-From: janpieter.sollie@edpnet.be
X-Barracuda-Effective-Source-IP: 212.71.9.157.dyn.edpnet.net[212.71.9.157]
X-Barracuda-Apparent-Source-IP: 212.71.9.157
Message-ID: <024e12e9-c61f-108a-e3c2-6f480ced4242@edpnet.be>
Date:   Fri, 29 Sep 2023 10:13:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] bcachefs: fix crc32c checksum merge byte order
 problem
To:     Kent Overstreet <kent.overstreet@linux.dev>,
        Brian Foster <bfoster@redhat.com>
X-ASG-Orig-Subj: Re: [PATCH 1/2] bcachefs: fix crc32c checksum merge byte order
 problem
Cc:     linux-bcachefs@vger.kernel.org
References: <20230927112338.262207-1-bfoster@redhat.com>
 <20230927112338.262207-2-bfoster@redhat.com>
 <20230927220821.7yomjka3xhrcr5xa@moria.home.lan> <ZRWJwu0nOZcHi0NC@bfoster>
 <20230928165759.fzqogoqdolqocd2e@moria.home.lan>
Content-Language: en-US, nl-BE
From:   Janpieter Sollie <janpieter.sollie@edpnet.be>
In-Reply-To: <20230928165759.fzqogoqdolqocd2e@moria.home.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: 212.71.9.157.dyn.edpnet.net[212.71.9.157]
X-Barracuda-Start-Time: 1695975312
X-Barracuda-URL: https://212.71.1.222:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 3772
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.114751
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org



Op 28/09/2023 om 18:57 schreef Kent Overstreet:
> On Thu, Sep 28, 2023 at 10:12:18AM -0400, Brian Foster wrote:
>> On Wed, Sep 27, 2023 at 06:08:21PM -0400, Kent Overstreet wrote:
>>> On Wed, Sep 27, 2023 at 07:23:37AM -0400, Brian Foster wrote:
>>>> An fsstress task on a big endian system (s390x) quickly produces a
>>>> bunch of CRC errors in the system logs. Most of these are related to
>>>> the narrow CRCs path, but the fundamental problem can be reduced to
>>>> a single write and re-read (after dropping caches) of a previously
>>>> merged extent.
>>>>
>>>> The key merge path that handles extent merges eventually calls into
>>>> bch2_checksum_merge() to combine the CRCs of the associated extents.
>>>> This code attempts to avoid a byte order swap by feeding the le64
>>>> values into the crc32c code, but the latter casts the resulting u64
>>>> value down to a u32, which truncates the high bytes where the actual
>>>> crc value ends up. This results in a CRC value that does not change
>>>> (since it is merged with a CRC of 0), and checksum failures ensue.
>>>>
>>>> Fix the checksum merge code to swap to cpu byte order on the
>>>> boundaries to the external crc code such that any value casting is
>>>> handled properly.
>>> Thanks! Applied.
>>>
>>> We really need to test creating a filesystem and then reading from it on
>>> an opposite endianness machine, have you gotten a chance to do that?
>>>
>> I gave it a quick test by just dd'ing the disk image off my fstests
>> TEST_DEV from the BE box I've been playing with and mounting it on a LE
>> system. The fs mounts, but eventually complains about a backpointer
>> issue after some stress I/O:
>>
>>   bcachefs (loop0): error validating btree node at btree backpointers level 0/1
>>     u64s 11 type btree_ptr_v2 0:5342578688:0 len 0 ver 0: seq 8574dcb72b17e918 written 486 min_key 0:3338403840:1 durability: 1 ptr: 0:10388:0 gen 6
>>     node offset 486 bset u64s 1300: invalid bkey: backpointer at wrong pos
>>     u64s 9 type backpointer 0:3339255808:0 len 0 ver 0: bucket=0:6369:0 btree=extents l=0 offset=0:256 len=64 pos=536913736:256:U32_MAX, shutting down
>>   bcachefs (loop0): inconsistency detected - emergency read only
>>   bcachefs (loop0): __bch2_btree_write_buffer_flush: insert error EIO
>>   bcachefs (loop0 inum 201326618 offset 246272): write error while doing btree update: EIO
>>
>> ... and fsck similarly complains about a bunch more bp and lru related
>> inconsistencies. Write buffer issue, perhaps? At a glance, that seq
>> value looks kind of bogus, but I haven't had a chance to dig into the
>> details yet. Everything seems in order with the same image file on the
>> BE box, FWIW.
> bch_backpointer looks highly suspect re: endianness, if it's not fixable
> we'll have to do a bch_backpointer_v2. I expect it will be fixable
> though, just tricky.
>
> The LRU btree is just a bitset btree now, so that shouldn't have
> endianness issues.
>
> So yeah, we definitely need to get automated foreign endianness testing
> going - if there's going to be more of this I don't want us to be doing
> this by hand, and we need to make sure issues like this get caught in
> the future.
>
> jpsollie was looking at ktest support for big endian architectures
> recently and had some patches for that, I just haven't had time to look
> at them - jpsollie, do you think you can post those patches to the list?


Currently finalizing them,

The issue is - mostly:
all BE architectures for debian are unofficial, and when you want to use a unofficial port,
you'll need to use debian sid, which is a trial-and-error when talking about dependencies

I'll create a patch of the commits in the PR.

Janpieter Sollie


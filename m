Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 380F6EB64DD
	for <linux-bcachefs@archiver.kernel.org>; Mon, 14 Aug 2023 01:17:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbjHNBRO (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 13 Aug 2023 21:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbjHNBRD (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 13 Aug 2023 21:17:03 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4BE518B
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Aug 2023 18:17:01 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3fe426b86a8so35477855e9.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Aug 2023 18:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=froggi.es; s=google; t=1691975820; x=1692580620;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=q7dFyi2gG/pK0aByc8gmA8iee7VihB0iMcJjdOSWB/0=;
        b=EXhl3ySKoHCvRGyjHQZiasbclE+fReQs3VRzIbSeZSuDok2jlaOhyoc9gVopF1k89G
         EpyrWgrRcPACfRihMs776ol6zHHTq5O+nMRBe5mf9h0ygtkL2OBzgHWqr41ANKCNPg4U
         y3C0ZgTvyT5tAyMj537PMafgCri5yXIIMV97fjdkwZ5c3xZdBRf77vL3bwnXrfTYOfKr
         dTXLaZoH53awTqM/AcqYAXwL1gudzYYzVeD90vwxNkSxizjwPmGu87tNSoFP8CtgVCyh
         dE+7jrGTajQYPrBMolor7x6sh7cK6nE3NQHwyaqru31fjcY/lgqvY2AK0BBPeUIuvRsf
         BxYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691975820; x=1692580620;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q7dFyi2gG/pK0aByc8gmA8iee7VihB0iMcJjdOSWB/0=;
        b=K1updOXewyQ4nzKXvnBYxq3TwMNLPzhTjYWbm+i7Iw2jCe4kUWMbsD3ssBNZiyYSSM
         cRt4HFrwDOnCPPHSL6JhNL1oUqffDXJICU0BycBm5pcbAP10RXVhm2Lfevh694hdZTqh
         PzsnH2BmWY5lrtylnEIpfu/amYqaiRMzespZIJfP43Mahj0Y7QsgnEHudzFvyjq+Msqd
         0h1KsFhsUCHPQEOftfp4r2mLRjf5WthB7gHoZd3SWI8SdqYSwYezWZBobTv5FTtzH4/f
         swoST1EUcr4djG9S68YZ74s/W6VfPuF08lHzYRk4VvoFFa9wAJ0MZKH8gjSEesuyb2I9
         fEAg==
X-Gm-Message-State: AOJu0YyolOj89tfw0fsXU+f5ng5jJR6psqMtpIqh6pDpaC/A1mZty1k+
        BQ3did7PtsmXJe78/PXQwu7G0tBMxBJJsVV+Uvw=
X-Google-Smtp-Source: AGHT+IEFEq8rGwedZWc1zmqHupG5bQCN5fKOkc7Qp0B3MurmYaYr8vqg5IfxbI0VGErq+Yxd0VwG2g==
X-Received: by 2002:a7b:cd19:0:b0:3fe:9a6:f44 with SMTP id f25-20020a7bcd19000000b003fe09a60f44mr6707098wmj.32.1691975820066;
        Sun, 13 Aug 2023 18:17:00 -0700 (PDT)
Received: from localhost.localdomain (darl-09-b2-v4wan-165404-cust288.vm5.cable.virginm.net. [86.17.61.33])
        by smtp.gmail.com with ESMTPSA id 8-20020a05600c228800b003fbcf032c55sm15694789wmf.7.2023.08.13.18.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Aug 2023 18:16:59 -0700 (PDT)
From:   Joshua Ashton <joshua@froggi.es>
To:     linux-bcachefs@vger.kernel.org
Cc:     Joshua Ashton <joshua@froggi.es>
Subject: [PATCH] tests/bcachefs/casefolding: New casefolding test
Date:   Mon, 14 Aug 2023 02:16:43 +0100
Message-ID: <20230814011658.623684-1-joshua@froggi.es>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Add a couple test to try out casefolding and a bunch of edgecases.

There is a decent amount of spam from the console of these as the
echos go to stdout too as it seems like set -x is applied somewhere.
---
 tests/bcachefs/casefolding.ktest | 192 +++++++++++++++++++++++++++++++
 1 file changed, 192 insertions(+)
 create mode 100755 tests/bcachefs/casefolding.ktest

diff --git a/tests/bcachefs/casefolding.ktest b/tests/bcachefs/casefolding.ktest
new file mode 100755
index 0000000..e318626
--- /dev/null
+++ b/tests/bcachefs/casefolding.ktest
@@ -0,0 +1,192 @@
+#!/usr/bin/env bash
+
+. $(dirname $(readlink -e "${BASH_SOURCE[0]}"))/bcachefs-test-libs.sh
+
+config-scratch-devs 1G
+config-scratch-devs 1G
+
+require-kernel-config CONFIG_UNICODE
+
+test_casefolding_simple()
+{
+    run_quiet "" bcachefs format -f --errors=panic ${ktest_scratch_dev[0]}
+    mount -t bcachefs ${ktest_scratch_dev[0]} /mnt
+
+    mkdir -p /mnt/non_cf
+    mkdir -p /mnt/cf
+    chattr +F /mnt/cf
+    mkdir -p /mnt/non_cf2
+
+    # Test basic casefolding
+    echo "test1" > /mnt/non_cf/BANANA
+    echo "test2" > /mnt/cf/BANANA
+    echo "test3" > /mnt/non_cf2/BANANA
+    cat /mnt/cf/banana
+    if cat /mnt/non_cf/banana ; then
+        echo "Was able to casefold in non-casefolding dir."
+        exit 1
+    fi
+    if cat /mnt/non_cf2/banana ; then
+        echo "Was able to casefold in non-casefolding dir."
+        exit 1
+    fi
+
+    echo "test4" > /mnt/non_cf/orange
+    echo "test5" > /mnt/cf/orange
+    echo "test6" > /mnt/non_cf2/orange
+    cat /mnt/cf/OrAnGE
+    if cat /mnt/non_cf/OrAnGE ; then
+        echo "Was able to casefold in non-casefolding dir."
+        exit 1
+    fi
+    if cat /mnt/non_cf2/OrAnGE ; then
+        echo "Was able to casefold in non-casefolding dir."
+        exit 1
+    fi
+
+    # Test copying doesn't persist hashes
+    mkdir -p /mnt/copy_test
+    cp /mnt/cf/orange /mnt/copy_test
+    cp /mnt/cf/BANANA /mnt/copy_test
+    cat /mnt/copy_test/orange
+    cat /mnt/copy_test/BANANA
+    if cat /mnt/copy_test/ORANGE ; then
+        echo "Was able to casefold after copy to non-cf dir"
+        exit 1
+    fi
+    if cat /mnt/copy_test/banana ; then
+        echo "Was able to casefold after copy to non-cf dir"
+        exit 1
+    fi
+
+    # Test moving doesn't persist hashes, etc
+    mkdir -p /mnt/rename_test
+    touch /mnt/rename_test/KIWI
+    echo "Kiwi" > /mnt/cf/kiwi
+    mv /mnt/cf/orange /mnt/rename_test
+    mv /mnt/cf/BANANA /mnt/rename_test
+    mv /mnt/cf/kiwi /mnt/rename_test/KIWI
+    cat /mnt/rename_test/orange
+    cat /mnt/rename_test/BANANA
+    cat /mnt/rename_test/KIWI
+    if cat /mnt/rename_test/ORANGE ; then
+        echo "Was able to casefold after move to non-cf dir"
+        exit 1
+    fi
+    if cat /mnt/rename_test/banana ; then
+        echo "Was able to casefold after move to non-cf dir"
+        exit 1
+    fi
+    if cat /mnt/rename_test/kiwi ; then
+        echo "Was able to casefold after move to non-cf dir"
+        exit 1
+    fi
+
+    # Test moving into a casefolding dir
+    echo "TOAD" > /mnt/toad
+    echo "frog" > /mnt/frog
+    mv /mnt/frog /mnt/cf/frog
+    cat /mnt/cf/FROG
+
+    touch /mnt/cf/TOAD
+    echo "toads" > /mnt/toads
+    mv /mnt/toad /mnt/cf/TOAD
+    mv /mnt/toads /mnt/cf/toads
+    cat /mnt/cf/toad
+    cat /mnt/cf/ToADS
+
+    # Test some non-ASCII characters
+    echo "greek" > /mnt/cf/greekἠἠἠἠaaaἠἠἠbἠ
+    echo "greek2" > /mnt/cf/aἈaἈaἈaἈaἈaἈa
+    echo "circle1" > /mnt/cf/ⓣⓣⓣⓣ
+    echo "circle2" > /mnt/cf/ⒺⒺⒺⒺⒺ
+    echo "cyrillic1" > /mnt/cf/уууу
+    echo "cyrillic2" > /mnt/cf/ППППП
+    echo "emoji" > /mnt/cf/🐸🐸✨✨🐸🐸
+    echo "japanese" > /mnt/cf/私はカエルです
+    echo "mixed1" > /mnt/cf/ἠB🐸ⓣ✨уⒺ✨蛙🐸ПaaL✨🐸
+    cat /mnt/cf/greekἨἨἨἨaaaἨἨἨbἨ
+    cat /mnt/cf/greekἨἠἠἨaaaἨἨἨbἠ
+    cat /mnt/cf/aἀaἀaἀaἀaἀaἀa
+    cat /mnt/cf/ⓉⓉⓉⓉ
+    cat /mnt/cf/ⓣⓉⓉⓣ
+    cat /mnt/cf/ⓉⓣⓣⓉ
+    cat /mnt/cf/ⓔⓔⓔⓔⓔ
+    cat /mnt/cf/УУУУ
+    cat /mnt/cf/УууУ
+    cat /mnt/cf/уУУу
+    cat /mnt/cf/ппппп
+    cat /mnt/cf/🐸🐸✨✨🐸🐸
+    cat /mnt/cf/私はカエルです
+    cat /mnt/cf/Ἠb🐸Ⓣ✨Уⓔ✨蛙🐸пAal✨🐸
+    cat /mnt/cf/ἠB🐸Ⓣ✨УⒺ✨蛙🐸ПaAL✨🐸
+    cat /mnt/cf/ἠb🐸Ⓣ✨уⒺ✨蛙🐸пaAL✨🐸
+
+    umount /mnt
+}
+
+test_casefolding_files()
+{
+    run_quiet "" bcachefs format -f --errors=panic ${ktest_scratch_dev[1]}
+    mount -t bcachefs ${ktest_scratch_dev[1]} /mnt
+
+    mkdir -p /mnt/cf_u
+    mkdir -p /mnt/cf_l
+    mkdir -p /mnt/cf_m
+    chattr +F /mnt/cf_u
+    chattr +F /mnt/cf_l
+    chattr +F /mnt/cf_m
+
+    # Make a set of uppercased files
+    for i in $(seq 1 512); do
+        echo -n A >> /mnt/temp_file_1
+       	echo "$i" > /mnt/cf_u/$(cat /mnt/temp_file_1)
+    done
+
+    # Make a set of lowercased files
+    for i in $(seq 1 512); do
+        echo -n a >> /mnt/temp_file_2
+       	echo "$i" > /mnt/cf_l/$(cat /mnt/temp_file_2)
+    done
+
+    # Make a set of mixed-case files
+    for i in $(seq 1 512); do
+        val=$([ "$i % 2" == 0 ] && echo "A" || echo "a")
+        echo -n $val >> /mnt/temp_file_3
+       	echo "$i" > /mnt/cf_m/$(cat /mnt/temp_file_3)
+    done
+
+    # Lookup an entirely lowercased version in the uppercase dir
+    for i in $(seq 1 512); do
+        echo -n a >> /mnt/temp_file_4
+        cat /mnt/cf_u/$(cat /mnt/temp_file_4)
+    done
+
+    # Lookup an entirely uppercased version in the uppercase dir
+    for i in $(seq 1 512); do
+        echo -n A >> /mnt/temp_file_5
+        cat /mnt/cf_u/$(cat /mnt/temp_file_5)
+    done
+
+    # Lookup an entirely uppercased version in the lowercase dir
+    for i in $(seq 1 512); do
+        echo -n A >> /mnt/temp_file_6
+        cat /mnt/cf_l/$(cat /mnt/temp_file_6)
+    done
+
+    # Lookup an entirely uppercased version in the mixed-case dir
+    for i in $(seq 1 512); do
+        echo -n A >> /mnt/temp_file_7
+        cat /mnt/cf_m/$(cat /mnt/temp_file_7)
+    done
+
+    # Lookup an entirely lowercased version in the mixed-case dir
+    for i in $(seq 1 512); do
+        echo -n a >> /mnt/temp_file_8
+        cat /mnt/cf_m/$(cat /mnt/temp_file_8)
+    done
+
+    umount /mnt
+}
+
+main "$@"
-- 
2.41.0

